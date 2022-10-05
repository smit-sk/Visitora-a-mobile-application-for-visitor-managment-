import 'package:flutter/material.dart';

class ChartHomePage extends StatefulWidget {
  const ChartHomePage({Key? key}) : super(key: key);

  @override
  _ChartHomePageState createState() => _ChartHomePageState();
}

class _ChartHomePageState extends State<ChartHomePage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20,),
          
            Text(
              "Analysis",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xff5E5E77),
              ),
            ),

             Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                "assets/images/report.png",
                fit: BoxFit.contain,
              ),
            ),
      
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:[
                 Container(
                // padding: EdgeInsets.fromLTRB(width * 0.06, height * 0.14, 0, 0),
                // alignment: Alignment.topLeft,
                child: Container(
                  height: height * 0.15,
                  width: width * 0.35,
                  decoration: BoxDecoration(
                    color: Color(0xffC6C7C4).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(21),
                  ),
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/barchart');
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bar_chart,
                          color: Color(0xff5E5E77),
                          size: 45,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "User Analysis",
                          style: TextStyle(
                            color: Color(0xff5E5E77),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            

             Container(
             
              // alignment: Alignment.topLeft,
              child: Container(
                height: height * 0.15,
                width: width * 0.35,
                decoration: BoxDecoration(
                  color: Color(0xffC6C7C4).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(21),
                ),
                // ignore: deprecated_member_use
                child: FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/groupedchart');
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.stacked_bar_chart,
                        color: Color(0xff5E5E77),
                        size: 45,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Vaccination Stacked Chart",
                        style: TextStyle(
                          color: Color(0xff5E5E77),
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),)]
            ),
            SizedBox(height: 20,),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    // padding: EdgeInsets.fromLTRB(width * 0.06, height * 0.14, 0, 0),
                    // alignment: Alignment.topLeft,
                    child: Container(
                      height: height * 0.15,
                      width: width * 0.35,
                      decoration: BoxDecoration(
                        color: Color(0xffC6C7C4).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(21),
                      ),
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/stackedlinechart');
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.stacked_line_chart,
                              color: Color(0xff5E5E77),
                              size: 45,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Vaccination Line Chart",
                              style: TextStyle(
                                color: Color(0xff5E5E77),
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //   // alignment: Alignment.topLeft,
                  //   child: Container(
                  //     height: height * 0.15,
                  //     width: width * 0.35,
                  //     decoration: BoxDecoration(
                  //       color: Color(0xffC6C7C4).withOpacity(0.8),
                  //       borderRadius: BorderRadius.circular(21),
                  //     ),
                  //     // ignore: deprecated_member_use
                  //     child: FlatButton(
                  //       onPressed: () {
                  //         Navigator.pushNamed(context, '/showdata');
                  //       },
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Icon(
                  //             Icons.insights,
                  //             color: Color(0xff5E5E77),
                  //             size: 45,
                  //           ),
                  //           SizedBox(
                  //             height: 10,
                  //           ),
                  //           Text(
                  //             "Data",
                  //             style: TextStyle(
                  //               color: Color(0xff5E5E77),
                  //               fontSize: 16,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // )
                ])
          ],
        ),
      ),
    );
  }
}
