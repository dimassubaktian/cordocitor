import 'package:cordocitor/models/qrcode_model.dart';
import 'package:cordocitor/providers/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modals/modals.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  QrCodeDbProvider qrcodeDb = QrCodeDbProvider();

  String result = '';
  List qrcodeData = [];
  bool modalIsShow = false;

  addQrCode(int id, String text) async {
    var qrcode = QrcodeModel(id: id, text: text, time: DateTime.now().toString());
    await qrcodeDb.addItem(qrcode);
  }

  void fetchQrcode() async {
    var qrcode = await qrcodeDb.fetchQrcode();
    setState(() {
      qrcodeData = qrcode;
    });
  }

  void deleteQrcode(int id) async {
    await qrcodeDb.deleteQrcode(id);
  }

  // override back button
  Future<bool> _onWillPop() async {
    return modalIsShow == false
        ? (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('Do you want to exit an App'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false), //<-- SEE HERE
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true), // <-- SEE HERE
                  child: const Text('Yes'),
                ),
              ],
            ),
          ))
        : false;
  }

  @override
  void initState() {
    super.initState();
    fetchQrcode();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text('QR Code Scanner'),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    if (modalIsShow == false) {
                      var res = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SimpleBarcodeScannerPage(),
                          ));
                      setState(() {
                        if (res is String && res != '-1') {
                          result = res;
                          addQrCode(qrcodeData.length + 1, result);
                          fetchQrcode();
                        }
                      });
                    } else {
                      //
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: const Color(0xFFAFD3E2),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: ListTile(
                              leading: Image.asset("assets/gif/qrcode.gif"),
                              title: const Text(
                                'SCAN',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                const Center(
                  child: Text(
                    'Result',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: qrcodeData.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (modalIsShow == false) {
                          showModal(
                            ModalEntry.aligned(
                              context,
                              tag: 'containerModal',
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 300,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.4),
                                        spreadRadius: 3,
                                        blurRadius: 10,
                                        offset: const Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'QRCode Value',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontFamily: 'Roboto',
                                              decoration: TextDecoration.none,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              removeAllModals();
                                              setState(() {
                                                modalIsShow = false;
                                              });
                                            },
                                            child: const Icon(Icons.close),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        height: 200,
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    await Clipboard.setData(ClipboardData(text: qrcodeData[index].text));
                                                  },
                                                  child: const Text('Copy to clipboard'),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Center(
                                                child: Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 13),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                  child: Text(
                                                    qrcodeData[index].text,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.normal,
                                                      color: Colors.black,
                                                      fontFamily: 'Roboto',
                                                      decoration: TextDecoration.none,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          //
                        }
                        setState(() {
                          modalIsShow = true;
                        });
                      },
                      child: ListTile(
                        leading: Image.asset("assets/images/qrcode.png"),
                        title: Text(qrcodeData[index].text),
                        subtitle: Text(DateFormat('yyyy-MM-dd - kk:mm').format(DateTime.parse(qrcodeData[index].time))),
                        trailing: IconButton(
                            onPressed: () {
                              deleteQrcode(qrcodeData[index].id);
                              fetchQrcode();
                            },
                            icon: const Icon(Icons.delete)),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
