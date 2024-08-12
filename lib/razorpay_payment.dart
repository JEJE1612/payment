import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayPayment extends StatefulWidget {
  const RazorpayPayment({super.key});

  @override
  State<RazorpayPayment> createState() => _RazorpayPaymentState();
}

class _RazorpayPaymentState extends State<RazorpayPayment> {
  late Razorpay _razorpay;
  TextEditingController amtController = TextEditingController();
  void openCheckout(amount) async {
    amount = amount * 100;
    var option = {
      "key": "rzp_test_1DB5mm0lF5G5ag",
      "amount": amount,
      "name": "Geeksfor Geeks",
      "prfill": {"contact": "1234567890", 'email': "test@gmail.com"},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(option);
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse respone) {
    Fluttertoast.showToast(
        msg: "Payment Succesful " + respone.paymentId!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void handlePaymentError(PaymentFailureResponse respone) {
    Fluttertoast.showToast(
        msg: "Payment Fail " + respone.message!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void handleExternalWallet(ExternalWalletResponse respone) {
    Fluttertoast.showToast(
        msg: "External Wallet" + respone.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentError);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Image.network(
              'https://www.google.com/imgres?q=logo%20of%20GeeksforGeeks&imgurl=https%3A%2F%2Fplay-lh.googleusercontent.com%2FZI21NMObsjB7DbPU_EXRymHJL3HQpfsrB2N4CWb-diXm4xjl_13mmetYQZvcpgGf-64&imgrefurl=https%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dfree.programming.programming%26hl%3Den_IN&docid=YOMoS_L7bQrWWM&tbnid=QDG-h3TLDjKFTM&vet=12ahUKEwi75KqKk_CHAxV2fKQEHVu2EOoQM3oECB0QAA..i&w=512&h=512&hcb=2&ved=2ahUKEwi75KqKk_CHAxV2fKQEHVu2EOoQM3oECB0QAA',
              width: 300,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Welcome to Razorpay Payment Gateway Integration ",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                cursorColor: Colors.white,
                autofocus: false,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    labelText: 'Enter Amount to paid ',
                    labelStyle: TextStyle(fontSize: 15.0, color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15)),
                controller: amtController,
                validator: (value) {
                  if (amtController.text.toString().isNotEmpty) {
                    setState(() {
                      int amount = int.parse(amtController.text.toString());
                      openCheckout(amount);
                    });
                  }
                },
              ),
            ),
            SizedBox(height: 30,),
            ElevatedButton(
             onPressed: (){
              if(amtController.text.toString().isNotEmpty){
                setState(() {
                  int amount = int.parse(amtController.text.toString());
                  openCheckout(amount);
                });
              }
             },
             child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Make Payment'),
             )
             ,style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green     
             ),
             )
          ],
        ),
      ),
    );
  }
}
