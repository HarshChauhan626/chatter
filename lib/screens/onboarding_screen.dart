import 'package:chat_app/screens/sign_in_screen.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:chat_app/utils/app_strings.dart';
import 'package:chat_app/widgets/custom_route_builder.dart';
import 'package:chat_app/widgets/custom_safe_area.dart';
import 'package:chat_app/widgets/slide_fade_transition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sizer/sizer.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  static const String routeName = '/onboarding';

  static Route route() {
    // return MaterialPageRoute(
    //   settings: const RouteSettings(name: routeName),
    //   builder: (_) => const OnboardingScreen(),
    // );
    return CustomRouteBuilder(page: const OnboardingScreen(),routeName: routeName);
  }

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _imageController = PageController();

  int nextPage=0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => _animateSlider());
  }

  void _animateSlider() {
    Future.delayed(const Duration(seconds: 2)).then((_) {
      if (nextPage <3) {
        // nextPage = 0;
        debugPrint(nextPage.toString());

        _imageController
            .animateToPage(nextPage,
            duration: const Duration(seconds: 1), curve: Curves.linear)
            .then((_) => _animateSlider());

        setState(() {
          debugPrint(_imageController.page!.round().toString());
          nextPage = _imageController.page!.round() + 1;
          debugPrint(nextPage.toString());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 80.h,
              child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _imageController,
                  itemCount: 3,
                  scrollBehavior: const MaterialScrollBehavior(),
                  itemBuilder: (context, index) {
                    return PageWidget(index:index);
                  }),
            ),
            SizedBox(
              height:13.h,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 20.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: SmoothPageIndicator(
                        controller: _imageController,
                        count: 3,
                        axisDirection: Axis.horizontal,
                        effect: const SlideEffect(
                            spacing: 8.0,
                            radius: 10.0,
                            dotWidth: 10.0,
                            dotHeight: 10.0,
                            paintStyle: PaintingStyle.stroke,
                            strokeWidth: 1.5,
                            dotColor: Colors.grey,
                            activeDotColor: AppColors.primaryColor),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:12.0),
                    child: OnboardingButton(
                        function: _animateSlider,
                        lastIndex:(nextPage-1)>=2
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SliderBox extends StatelessWidget {
  final Widget child;
  const SliderBox({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(10), child: child);
  }
}


class PageWidget extends StatefulWidget {
  final int index;
  const PageWidget({Key? key,required this.index}) : super(key: key);

  @override
  _PageWidgetState createState() => _PageWidgetState();
}

class _PageWidgetState extends State<PageWidget> with AutomaticKeepAliveClientMixin{

  List<String> svgList=[
    "chatting.svg",
    "mobile_messages.svg",
    "online_discussion.svg"
  ];

  List<String> titleList=[
    AppStrings.onBoardingTitle1,
    AppStrings.onBoardingTitle2,
    AppStrings.onBoardingTitle3,
  ];

  List<String> subtitleList=[
    AppStrings.onBoardingSubTitle1,
    AppStrings.onBoardingSubTitle2,
    AppStrings.onBoardingSubTitle3,
  ];


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 450.0,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SvgPicture.asset("assets/${svgList[widget.index]}"),
        ),
        const SizedBox(
          height: 80.0,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0,10.0,10.0,10.0),
              child: SlideFadeTransition(
                  child: Text(
                    titleList[widget.index],
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0,10.0,10.0,10.0),
              child: SlideFadeTransition(
                  child: Text(
                    subtitleList[widget.index], style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        color: Colors.grey[500]
                    ),
                  )),
            )
          ],
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}




class OnboardingButton extends StatefulWidget {
  Function function;
  bool lastIndex;
  OnboardingButton({Key? key,required this.function,required this.lastIndex}) : super(key: key);

  @override
  _OnboardingButtonState createState() => _OnboardingButtonState();
}

class _OnboardingButtonState extends State<OnboardingButton> with SingleTickerProviderStateMixin{

  late final AnimationController _controller;

  bool end=false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
      setState(() {

      });
    });
    toggleEndButton();
    // <-- Set your duration here.
  }

  void toggleEndButton(){
    end=widget.lastIndex;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Onboarding button called");
    return CustomSafeArea(
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          !widget.lastIndex?Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              child: Text("Skip",style: Theme.of(context).textTheme.button?.copyWith(
                  color: AppColors.greyColor,
                  fontSize: 18.0
              ),
              ),
              onPressed: (){

              },
            ),
          ):const SizedBox(),
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            alignment: widget.lastIndex?Alignment.center:Alignment.centerRight,
            child: SizedBox(
              width: widget.lastIndex?92.w:40.w,
              child: ElevatedButton(
                onPressed: (){
                  if(widget.lastIndex){
                    Navigator.pushReplacementNamed(context, SignInScreen.routeName);
                  }
                  else{
                    widget.function();
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.lastIndex?"Get started":"Next",style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Colors.white
                    ),),
                    SizedBox(
                      width: 2.w,
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 25.0,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

}



