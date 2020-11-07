import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  var data = await readData();

  if (data != null) {
    String message = await readData();
    print(message);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LLoginScreen1(),
    );
  }
}

class LLoginScreen1 extends StatefulWidget {
  @override
  _LLoginScreen1State createState() => _LLoginScreen1State();
}

class _LLoginScreen1State extends State<LLoginScreen1> {
  final TextEditingController _userConttroller = new TextEditingController();
  final TextEditingController _passConttroller = new TextEditingController();
  final TextEditingController _userTextConttroller =
      new TextEditingController();

  List<String> _loadDat = [];
  List<String> _bufferDat = [];

  String rout = 'Velcom';
  String dyspleyText = 'Войти';
  bool ends = false;

  var user = '';
  var pass = '';
  bool focus = false;
  bool start = false;

  void calculate(String data) {
    _bufferDat.add(data);
    print('data $data');
    print('loadData $_loadDat');
    print('buferData $_bufferDat');
    setState(() {});
  }

  void load() async {
    var dat = await readData();
    _loadDat = dat.split("\n");
    if (dat != 'no filed') {
      user = _loadDat[0];
      pass = _loadDat[1];
      for (int num = 2; num < _loadDat.length; num++) {
        _bufferDat.add(_loadDat[num]);
      }
    }

    print('res = $_loadDat');
    print('dat = $dat');
  }

  void save() {
    _loadDat = [];
    _loadDat.add(user);
    _loadDat.add(pass);
    for (int num = 0; num < _bufferDat.length; num++) {
      _loadDat.add(_bufferDat[num]);
    }
    String complect = _loadDat.join('\n');
    print('1 $_loadDat');
    print('calc > $complect');
    writeData(complect);
  }

  void logIn() {
    var user;
    var pass;
    if (_userConttroller.text.isNotEmpty && _passConttroller.text.isNotEmpty) {

      user = _userConttroller.text;
      pass = _passConttroller.text;

      if (user == _loadDat[0] && pass == _loadDat[1]) {
        print('зарегился >>> $_loadDat');
        print('переход от на 3 экран');
        setState(() {
          rout = 'Corect';
        });
      } else {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  elevation: 24.0,
                  backgroundColor: Colors.white,
                  title: Text('Ошибка'),
                  content: Text('Попробовать сного'),
                  actions: [
                    FlatButton(
                      child: Text('Да'),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ));
      }
    } else
      print('Поля должны быть заполненны');
  }

  void newUser() {
    if (_userConttroller.text.isNotEmpty && _passConttroller.text.isNotEmpty) {
      user = _userConttroller.text;
      pass = _passConttroller.text;
      _loadDat = [];
      _loadDat.add(user);
      _loadDat.add(pass);
      _bufferDat = [];

      print('New User Saved');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                elevation: 24.0,
                backgroundColor: Colors.white,
                title: Text('Новый пользователь добавлен'),
                content: Text('Продолжить?'),
                actions: [
                  FlatButton(
                      child: Text('Да'),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          //focus = true;
                          rout = 'Velcom';
                        });
                      })
                ],
              ));
    } else
      print('Поля должны быть заполненны');
  }

  Future<bool> _onBackPressed() async {
    if (rout == 'register') {
      setState(() {
        rout = 'Velcom';
      });
    } else if (rout == 'Corect') {
      setState(() {
        rout = 'Velcom';
      });
    } else {
      final alertDialog = AlertDialog(
        content: Text("Вы уверены что хотите выйти из приложения?"),
        actions: <Widget>[
          FlatButton(
              child: Text('Да'),
              onPressed: () {
                save();
                SystemNavigator.pop();
              }),
          FlatButton(
            child: Text('Нет'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      );
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => alertDialog);
    }
    return false;
  }

  // TODO: LIST
  
  Widget me(int index) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 20.0),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.black,
                        ),
                        
                        width: 10,
                        height: 10,
                      ),
                      SizedBox(width: 20.0),
                      Flexible(
                        child: Text(
                          '${_bufferDat[index]}',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      iconSize: 40.0,
                      icon: Icon(Icons.remove_circle_outline),
                      color: Colors.black,
                      onPressed: () {
                        print('OK tup!!!');
                        setState(() {
                          _bufferDat.removeAt(index);
                        });
                      },
                    ),
                    SizedBox(width: 10.0),
                  ],
                ),
              ],
            ),
          ),
          Divider(color: Colors.black, height: 10.0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    if (!start) {
      start = true;
      load();
    }

    Widget newMessage = Material(
      child: Container(
        color: Colors.brown[100],
        height: 150.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 25.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/logo02.png",
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 20.0),
                  Text(
                    user,
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    height: 80.0,
                    color: Colors.brown[100],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextField(
                            style: TextStyle(fontSize: 20.0),
                            controller: _userTextConttroller,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              isCollapsed: true,
                              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0,
                                  20.0, 10.0),
                              hintText: "Введите текст",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 80.0,
                    color: Colors.brown[100],
                    child: IconButton(
                      iconSize: 40.0,
                      icon: Icon(Icons.add),
                      color: Colors.black,
                      onPressed: () {
                        if (_userTextConttroller.text.isNotEmpty) calculate(_userTextConttroller.text);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    final emailField = TextField(
      // onTap: () {
      //   setState(() {
      //     focus = false;
      //   });
      // },
      // readOnly: focus,
      //autofocus: focus,
      style: TextStyle(fontSize: 20.0),
      controller: _userConttroller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Логин",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    final newEmailField = TextField(
      style: TextStyle(fontSize: 20.0),
      controller: _userConttroller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Логин",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final passwordField = TextField(
      obscureText: true,
      style: TextStyle(fontSize: 20.0), // 20
      controller: _passConttroller,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(
              20.0, 15.0, 20.0, 15.0), //20.0, 15.0, 20.0, 15.0
          hintText: "Пароль",
          fillColor: Colors.red,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0))), // 32 circ..
    );
    final newPasswordField = TextField(
      obscureText: true,
      style: TextStyle(fontSize: 20.0), // 20
      controller: _passConttroller,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(
              20.0, 15.0, 20.0, 15.0), //20.0, 15.0, 20.0, 15.0
          hintText: "Пароль",
          fillColor: Colors.red,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0))), // 32 circ..
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          logIn();
        },
        child: Text(dyspleyText,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );

    final newLoginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          newUser();
        },
        child: Text("Зарегистрироваться",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );

    // TODO: Velcom
    
    //------------------------------- скрин ожидания ввода лога и пароля ----------------------------------------------
    
    print('ok!');
    if (rout == 'Velcom')
      return WillPopScope(
        onWillPop: _onBackPressed,
        child: SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(36.0), // 36
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 200.0,
                            child: Center(
                              child: SizedBox(
                                height: 100.0,
                                child: Image.asset(
                                  "images/logo02.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 48.0), // 48
                          emailField,
                          SizedBox(height: 24.0), // 24
                          passwordField,
                          SizedBox(
                            height: 36.0, // 36
                          ),
                          loginButton,
                          SizedBox(
                            height: 36.0, // 16
                          ),
                          RichText(
                              text: TextSpan(
                                  text: 'Регистрация',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 18.0),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      print('Регистрация');
                                      setState(() {
                                        rout = 'register';
                                      });
                                    })),
                          SizedBox(
                            height: 36.0, // 16
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    else if (rout == 'Corect')
      
      //TODO: Corect
      
      //------------------------------- Скрин входа после правильного ввода лога и пароля ----------------------------------------------
      
      return WillPopScope(
        onWillPop: _onBackPressed,
        child: SafeArea(
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.brown[100],
                  pinned: true,
                  expandedHeight: 250.0,
                  collapsedHeight: 120.0,
                  floating: false,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: newMessage,
                    titlePadding:
                        EdgeInsetsDirectional.only(start: 0, bottom: 0, end: 0),
                    background: Container(
                      color: Colors.brown[100],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return WillPopScope(
                          onWillPop: _onBackPressed, child: me(index));
                    },
                    childCount: _bufferDat.length,
                  ),
                )
              ],
            ),
          ),
        ),
      );

    else
      
      //TODO Register
      
      //-------------------------------   скрин регистрации   ----------------------------------------------
      
      return WillPopScope(
        onWillPop: _onBackPressed,
        child: SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(36.0), // 36
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 200.0,
                          child: Center(
                            child: SizedBox(
                              height: 100.0,
                              child: Image.asset(
                                "images/logo02.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 48.0), // 48
                        newEmailField,
                        SizedBox(height: 24.0), // 24
                        newPasswordField,
                        SizedBox(
                          height: 36.0, // 36
                        ),
                        newLoginButton,
                        SizedBox(
                          height: 36.0, // 16
                        ),
                        RichText(
                            text: TextSpan(
                                text: 'Назад',
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 18.0),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print('Назад');
                                    setState(() {
                                      rout = 'Velcom';
                                    });
                                  }))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
  }
}

Future<String> get _localPath async {
  final directory = await getApplicationSupportDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/userdata.txt');
}

Future<File> writeData(String userdata) async {
  final file = await _localFile;
  return file.writeAsString('$userdata');
}

Future<String> readData() async {
  try {
    final file = await _localFile;
    String data = await file.readAsString();
    return data;
  } catch (e) {
    return 'no filed';
  }
}