import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_handymappisioma/servicemap.dart';
import 'package:flutter_handymappisioma/services.dart';
import 'package:flutter_handymappisioma/worker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// class MyAppTwo extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MyHomePage();
//   }
// }

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseDatabase dref = FirebaseDatabase.instance;
  late DatabaseReference dbref;

  Future<List<ServiceDataModel>> getData() async {
    List<ServiceDataModel> data = [];

    dynamic category = (await dref.ref().get()).value as Map<dynamic, dynamic>;
    //worker id, information
    category.forEach((category, worker) {
      //IF you want to use the ID of the workers, change the "from(value).values" to "from(value).keys"
      // data.add(ServiceDataModel(name: category, workers: workers));
      Map<String, dynamic> workerMap = Map<String, dynamic>.from(worker);
      List<Worker> workers = [];
      workerMap.forEach((key, value) {
        if (key.length > 5) {
          //todo remove
          workers.add(Worker(
              id: key,
              phoneNumber: value["phoneNo"],
              location: LatLng(double.parse(value["location"].split(",")[0]),
                  double.parse(value["location"].split(",")[1])),
              name: value["name"]));
        }
      });
      data.add(ServiceDataModel(name: category, workers: workers));
    });
    return data;
  }

  @override
  void initState() {
    super.initState();
  }

  // static List<String> services = [
  //   'Carpentry',
  //   'Plumbing',
  //   'Painting',
  //   'Electrics',
  // ];

  // static List url = [
  //   'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Beslag_13_%28ubt%29.JPG/800px-Beslag_13_%28ubt%29.JPG?20120715215745',
  //   'https://upload.wikimedia.org/wikipedia/commons/thumb/e/ed/A_hidden_face.jpg/800px-A_hidden_face.jpg?20100109121720',
  //   'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/Art-wall-brush-painting_%2823698214684%29.jpg/800px-Art-wall-brush-painting_%2823698214684%29.jpg?20160916050735',
  //   'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8f/Defense.gov_photo_essay_080826-F-0000V-001.jpg/750px-Defense.gov_photo_essay_080826-F-0000V-001.jpg?20120918215052'
  // ];

  // final List<ServiceDataModel> Servicesdata = List.generate(
  //     services.length,
  //     (index) => ServiceDataModel(
  //         '${services[index]}', '${services[index]} Description...'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Services'),
      ),
      body: FutureBuilder<List<ServiceDataModel>>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(snapshot.data![index].name),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ServiceDetail(
                                    serviceDataModel: snapshot.data![index],
                                  )));
                        },
                      ),
                    );
                  });
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
