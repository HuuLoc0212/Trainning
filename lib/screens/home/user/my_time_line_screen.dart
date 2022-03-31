import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:start/constants/constants.dart';
import 'package:start/data/network/constants/constants.dart';
import 'package:start/data/network/graphql_client.dart';
import 'package:start/model/timeline/collection.dart';
import 'package:start/model/timeline/timeline.dart';
import 'package:start/screens/home/user/widgets/CustomTextField.dart';
import 'package:start/widgets/app.dart';

class MyTimeLineScreen extends StatefulWidget {
  const MyTimeLineScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyTimeLineScreenState();
}

class _MyTimeLineScreenState extends State<MyTimeLineScreen> {
  late Future<List<MyTimeline>> timelineListFT;
  late List<MyTimeline> timelineList;
  Map<String, bool> map = {};

  //ScrollController _scrollController = ScrollController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  //
  String _startDate = '';
  String _endDate = '';

  //datetime - picker
  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        var date =
            "${picked.toLocal().year}-${picked.toLocal().month}-${picked.toLocal().day}";
        controller.text = date;


        //Check distance between 2 date
        DateTime sDate = DateFormat("yyyy-MM-dd").parse(_startDateController.text);
        DateTime eDate = DateFormat("yyyy-MM-dd").parse(_endDateController.text);
        final difference = sDate.difference(eDate).inDays;
       print(difference);
       print(_startDateController.text);
       print(_endDateController.text);
        timelineListFT = getTimeline(
            startDate: _startDateController.text, endDate: _endDateController.text);
      });
    }
  }

  //FormatDate: yyyy-MM-dd
  // mac dinh trong vong 1 thang gan nhat. 
  
  Future<List<MyTimeline>> getTimeline(
      {required String startDate, required String endDate}) async {
    await Future.delayed(const Duration(seconds: 1));
    // goi len server 
    QueryResult queryResult = await GraphQLConfig.client().value.query(
          QueryOptions(
            document: gql(GraphQLConstants.myTimeLine),
            variables: {
              "input": {"startDate": startDate, "endDate": endDate}
            },
          ),
        );
        //kiem tra ( neeu goi len bi loi thi tra ve lisst rong)
    if (queryResult.data!['myTimeLine']['error']['requestResolved'] == false) {
      print(queryResult.data!['myTimeLine']['error']['message']);
      return [];
    } else {
      // true lay duoc resp .- kiem tra respon co rong khong 

      // reponse la 1 list 
      //list la dynamic  


      List<dynamic> responseList = queryResult.data!['myTimeLine']['response'];
      print(responseList.length);
      if (responseList.isEmpty) {
        return [];
        // kiem tra rong
        // kiem tra responseList
      } 
      // neu res co du lieu thi conver nhung gia tri trong responseList sang object mytimeline
      else {
        List<MyTimeline> timelineList = [];
        for (int i = 0; i < responseList.length; i++) {
          timelineList.add(MyTimeline.fromJson(responseList[i]));
        }// tao list 
        return timelineList;
      }
    }
  }

  @override
  void initState() {
    DateTime now = DateTime.now();
    DateTime newDate = DateTime(now.year, now.month - 1, now.day);
    _startDateController.text = DateFormat("yyyy-MM-dd").format(newDate);
    _endDateController.text = DateFormat("yyyy-MM-dd").format(now);
    timelineListFT = getTimeline(
        startDate: _startDateController.text, endDate: _endDateController.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //getTimeline();
    return Scaffold(
      appBar: createAppbar(
        context,
        title: 'My Timeline',
      ),
      // FutureBuilder tra ve list mytim
      body: FutureBuilder<List<MyTimeline>>(
       // future lay du lieu 
        future: timelineListFT,
        // onnectionState == ConnectionState.waiting( tg cho )
        builder: (context, AsyncSnapshot<List<MyTimeline>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('waiting');
            return Container(
                color: Colors.grey.withOpacity(0.2),
                child: const Center(child: CircularProgressIndicator()));
          }
          // lay duoc du lieu connect 
          else if (snapshot.connectionState == ConnectionState.done) {
           // neu no rong thi bao ve nothing 
            if (snapshot.hasData) {
              timelineList = snapshot.data ?? [];
              // timelinelis bang gia tri ma future lay ve, kiem tra rong thi tra ve nothing 
              if (timelineList.isEmpty) {
                return const Center(child: Text('Nothing'));  // neu no rong thi bao ve nothing 
              } else {
                // for (int i = 0; i < timelineList.length; i++) {
                //   map.addAll({'isExpanded${i.toString()}': false});
                // }
                // print(map);
                return Container(
                  color: primaryColor,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: borderRadius(20.0, 20.0, 0.0, 0.0),
                    ),
                    child: SingleChildScrollView(
                      primary: true,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 10.0),
                            child: _buildChooseDate(),
                          ),
                          // render list mytimeline hien thi group date 
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: timelineList.length,
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemBuilder: (context, index) {
                              return _buildItemTimeLine(
                                index: index,
                                timelineList: timelineList,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(child: Text('Error'));
            }
          }
          return Container();
        },
      ),
    );
  }

  ///Pick date
  _buildChooseDate() {
    return Row(
      children: <Widget>[
        Flexible(
          child: GestureDetector(
            onTap: () => _selectDate(context, _startDateController),
            child: AbsorbPointer(
              child: CustomTextField(
                controller: _startDateController,
                title: 'From',
                isImportant: true,
                hintText: 'Choose',
                textInputType: TextInputType.datetime,
                suffixIcon: Icon(Icons.calendar_today_outlined,
                    color: Colors.black.withOpacity(0.5)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        Flexible(
          child: GestureDetector(
            onTap: () => _selectDate(context, _endDateController),
            child: AbsorbPointer(
              child: CustomTextField(
                controller: _endDateController,
                title: 'To',
                isImportant: true,
                hintText: 'Choose',
                textInputType: TextInputType.datetime,
                suffixIcon: Icon(Icons.calendar_today_outlined,
                    color: Colors.black.withOpacity(0.5)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  ///---------------------------------------------------------------------------
  bool isExpanded = false;
// truyen list va vi tri
  _buildItemTimeLine(
      {required int index, required List<MyTimeline> timelineList}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
          // map.update(('isExpanded${index.toString()}'),
          //     (value) => !(map['isExpanded${index.toString()}'] ?? false));
        });
        //print(map['isExpanded${index.toString()}']);
      },
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 70,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Container(
                      color: primaryColor,
                      width: 70,
                      height: 70,
                      child: const Icon(Icons.calendar_today_sharp,
                          color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(timelineList[index].groupDate!,
                          style: const TextStyle(fontSize: 18)),
                    ),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: primaryColor,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // neu gia tri la true thi se render 1 list nua. list do la connection 
          isExpanded
              ? ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context, i) {
                    return const Divider();
                  },
                  itemBuilder: (context, i) {
                    return _buildItemCollection(
                        col: timelineList[index].collections, index: i);
                  },
                  itemCount: timelineList[index].collections!.length)
              : const SizedBox(height: 0, width: 0)
        ],
      ),
    );
  }
  // render danh sach items theo tung group date 
  _buildItemCollection({required List? col, required int index}) {
    //print(col![index]);
    Collection collection = Collection.fromJson(col![index]);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 40.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(collection.activityTypes ?? 'TYPE'),
                    Text(collection.activityDescription ?? 'Description',
                        style: const TextStyle(color: Colors.grey))// bat loi null
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//

}
