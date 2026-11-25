import 'dart:async';
import 'dart:developer';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../domain/entities/parameter/subscription_parameter.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final SubscriptionParameter paymentData;

  static const routeName = '/payment-webview';

  const PaymentWebViewScreen({
    required this.paymentData,
    super.key,
  });

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  bool checked = false;
  bool isLoading = true;
  late final WebViewController _controller;
  bool _hasInit = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // _controller.
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (!_hasInit) {
      _hasInit = true;
      if (kIsWeb) {
        setState(() => isLoading = false);
      } else {
        _controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..addJavaScriptChannel(
            'Toaster',
            onMessageReceived: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message.message)),
              );
            },
          )
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (progress) {
                // Update loading bar.
              },
              onPageStarted: (url) {
                log('Page started loading: $url');
                setState(() => isLoading = true);
                checkPayment(url);
              },
              onPageFinished: (url) {
                log('Page finished loading: $url');
                setState(() => isLoading = false);
                checkPayment(url);
              },
              onWebResourceError: (error) {},
              onNavigationRequest: (request) {
                log('startRef');
                final url = request.url;
                if (url.contains('status=failed') ||
                    url.contains('status=success')) {
                  checkPayment(url);
                  return NavigationDecision.prevent;
                }
                if (url.contains('snapchat')) {
                  return NavigationDecision.prevent;
                }
                if (url.contains('youtube')) {
                  return NavigationDecision.prevent;
                }
                if (url.contains('twitter')) {
                  return NavigationDecision.prevent;
                }
                if (url.contains('instagram')) {
                  return NavigationDecision.prevent;
                }
                if (url.contains('facebook')) {
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          );
        //loadRequest(Uri.parse(widget.paymentData.formUrl,));
        final Uri uri = Uri.parse(widget.paymentData.formUrl);

        // 2. جهز الـ Parameters
        // final paramsEntity = widget.paymentData.parameters;
        // final paramsMap = PaymentParameterDTO.fromEntity(paramsEntity).toMap();

        // final bodyString = paramsMap.entries
        //     .map((e) =>
        //         '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}')
        //     .join('&');

        // final bodyBytes = Uint8List.fromList(utf8.encode(bodyString));

        _controller.loadRequest(uri);

        log('PaymentUrl (GET): ${widget.paymentData.formUrl}');
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await popWebView(context);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () async {
              await popWebView(context);
            },
          ),
          title: MainText(
            context.l10n.payment,
            color: MyColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 50,
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: FittedBox(
                    child: MainText(
                      context.l10n.please_close_payment_process_complete,
                      textAlign: TextAlign.center,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  child: kIsWeb
                      ? _buildWebPaymentPlaceholder()
                      : WebViewWidget(
                          controller: _controller,
                        ),
                ),
              ],
            ),
            if (isLoading)
              Container(
                color: Colors.white.withValues(alpha: 0.7),
                child: const Center(
                  child: SpinKitFadingCircle(
                    color: MyColors.primaryColor,
                    size: 50.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void checkPayment(String? url) {
    if (url == null) {
      return;
    }
    log("Checking URL in onPageFinished: $url");
    if (url.contains('status=failed')) {
      if (!checked) {
        setState(() => checked = true);
        log('payment not success');
        Fluttertoast.showToast(
          msg: context.l10n.payment_failed,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: MyColors.appRed,
          textColor: Colors.white,
          fontSize: 14.0,
        );
        Navigator.of(context).pop(false);
      }
    } else if (url.contains('status=success')) {
      log('Payment process finished (from onPageFinished). Redirecting...');
      if (!checked) {
        setState(() => checked = true);
        Future.delayed(Duration.zero, () {
          if (!mounted) return;
        });
      }
    }
  }

  Widget _buildWebPaymentPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: MyColors.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.payment_rounded,
              size: 64,
              color: MyColors.primaryColor,
            ),
          ),
          const SizedBox(height: 32),
          MainText(
            context.l10n.payment_confirmation,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: MainText(
              context.isArabic
                  ? "سيتم فتح بوابة الدفع في نافذة جديدة. يرجى إتمام العملية هناك."
                  : "Payment gateway will open in a new window. Please complete the process there.",
              textAlign: TextAlign.center,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: 300,
            child: MainButton(
              title:
                  context.isArabic ? "فتح بوابة الدفع" : "Open Payment Gateway",
              onPressed: () async {
                final url = widget.paymentData.formUrl;
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(
                    Uri.parse(url),
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Could not launch payment URL')),
                    );
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () {
            },
            child: MainText(
              context.isArabic
                  ? "لقد أتممت الدفع بالفعل؟ اضغط هنا"
                  : "Already completed payment? Click here",
              color: MyColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> popWebView(BuildContext context) async {
    if (!context.mounted) return;

    Navigator.of(context).pop(false);
  }
}
