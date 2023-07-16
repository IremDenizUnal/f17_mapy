import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mapy/order_tracking_page.dart';







class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  int _currentIndex = 0;

  final List<Widget> _pages = [
    AnaSayfa(),
    Haritalar(),
    Profil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Merhaba Sürücü'),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Harita',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class AnaSayfa extends StatefulWidget {
  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  final List<String> sonRotalar = [
    'Atatürk Okulu',
    'Kızılay AVM',
    'Ev',

  ];

  final List<String> favoriRotalar = [
    'Ev',
    'Antalya Lisesi',
    'a İş Merkezi',

  ];

  String havaDurumu = '';

  Future<String> fetchHavaDurumu() async {
    // Hava durumu servisine istek yapılıyor
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=Ankara&appid=YOUR_API_KEY'));

    if (response.statusCode == 200) {
      // İstek başarılı ise JSON verisinden hava durumu değeri alınıyor
      final data = jsonDecode(response.body);
      final main = data['weather'][0]['main'];
      final description = data['weather'][0]['description'];
      return '$main, $description';
    } else {
      throw Exception('Hava durumu yüklenirken hata oluştu.');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchHavaDurumu().then((value) {
      setState(() {
        havaDurumu = value;
      });
    }).catchError((error) {
      print('Hata: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Text(
            'Hava Durumu:',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 14),
          Text(
            havaDurumu.isEmpty ? 'Yükleniyor...' : havaDurumu,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 30),
          Text(
            'Son Rotalarım:',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 14),
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: sonRotalar.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: 8),
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Center(
                    child: Text(
                      sonRotalar[index],
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 25),
          Text(
            'Favori Rotalarım:',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 14),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: favoriRotalar.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),

                child: ListTile(
                  title: Text(
                    favoriRotalar[index],
                    style: TextStyle(fontSize: 18),
                  ),
                  leading: Icon(Icons.favorite),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}



class Haritalar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        body: Center(
          child: Image.asset(
            'assets/images/harita.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}




/*class Haritalar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderTrackingPage()),
    );

  }
}
*/
/*class Haritalar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrderTrackingPage()),
      ),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // Check if the future has completed
        if (snapshot.connectionState == ConnectionState.done) {
          // Handle the result if needed
          // For example, you can access the result using snapshot.data
          // and return a widget based on the result
          return Container(); // Replace with the appropriate widget
        } else {
          // While the future is still loading, you can return a loading indicator
          return CircularProgressIndicator();
        }
      },
    );
  }
}
*/

class Profil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[ CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/images/profile_image.png'),
              ),

                Text(
                  'İrem Deniz Ünal',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 25),
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    // Ayarlar butonuna tıklandığında gelecek sayfa
                  },
                ),

              ]
          ),
          SizedBox(height: 16),
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children:[ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    primary: Colors.grey
                ),
                child: Text(
                  "Profili düzenle",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),]
          ),
          SizedBox(height: 30),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child:  Center(
              child: Image.asset(
                'assets/images/qr.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(height: 30),
          Text(
            'Kişisel Bilgiler',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          ListTile(
            leading: Icon(Icons.accessibility),
            title: Text('Kan Grubu'),
            subtitle: Text('A+'),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Doğum Tarihi'),
            subtitle: Text('24.01.1995'),
          ),

        ],
      ),
    );
  }
}


