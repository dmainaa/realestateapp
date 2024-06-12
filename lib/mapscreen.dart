import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:realestateapp/customnavbar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  TextEditingController _searchController =
      TextEditingController(text: "Saint Petersburg");

  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _menuController;
  late Animation<double> _menuAnimation;
  late Animation<AlignmentGeometry> _alignmentAnimation;

  bool _isMenuVisible = false;
  String _selectedOption = "Price";
  bool _isPositionedContainersVisible = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _menuController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _menuAnimation = CurvedAnimation(
      parent: _menuController,
      curve: Curves.easeInOut,
    );

    _alignmentAnimation = AlignmentTween(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    ).animate(_menuController);

    // Delay the appearance of positioned containers by 1 second
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isPositionedContainersVisible = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _menuController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isMenuVisible = !_isMenuVisible;
      if (_isMenuVisible) {
        _menuController.forward();
      } else {
        _menuController.reverse();
      }
    });
  }

  void _selectOption(String option) {
    setState(() {
      _selectedOption = option;
      _toggleMenu(); // Dismiss the menu
    });
  }

  void _dismissMenu() {
    if (_isMenuVisible) {
      setState(() {
        _isMenuVisible = false;
        _menuController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: GestureDetector(
        onTap: _dismissMenu,
        child: Stack(
          children: [
            SizedBox(
              height: height,
              width: width,
              child: Image.asset(
                "assets/map.jpeg",
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 25,
              left: 30,
              right: 30,
              child: ScaleTransition(
                scale: _animation,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        width: width * 0.70,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100)),
                        child: Row(
                          children: [
                            const Icon(Icons.search),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextField(
                                style: const TextStyle(
                                    fontFamily: 'Euclid Circular A',
                                    fontSize: 14),
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white),
                      height: 50,
                      width: 50,
                      child: const Icon(Icons.sort_sharp),
                    ),
                  ],
                ),
              ),
            ),
            if (_isPositionedContainersVisible) ...[
              createPositionedContainer(80, 100),
              createPositionedContainer(100, 380),
              createPositionedContainer(210, 500),
              createPositionedContainer(70, 200),
              createPositionedContainer(200, 250),
              createPositionedContainer(250, 400),
            ],
            Positioned(
              left: 25,
              bottom: 100,
              right: 25,
              child: ScaleTransition(
                scale: _animation,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        InkWell(
                          onTap: _toggleMenu,
                          splashColor: const Color(0xfffcb117),
                          customBorder: const CircleBorder(),
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: const Color(0xff919394).withOpacity(0.9),
                                borderRadius: BorderRadius.circular(100)),
                            child: const Icon(
                              Icons.wallet_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: const Color(0xff919394).withOpacity(0.9),
                              borderRadius: BorderRadius.circular(100)),
                          child: const Icon(
                            Icons.navigation,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color(0xff919394).withOpacity(0.9),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.list,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "List of variants",
                            style: TextStyle(
                                fontFamily: "Euclid Circular A",
                                color: Colors.white),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 150, // Adjust the bottom position to cover the wallet icon
              left: 25,
              right: 25,
              child: AlignTransition(
                alignment: _alignmentAnimation,
                child: SizeTransition(
                  sizeFactor: _menuAnimation,
                  axisAlignment: -1.0,
                  child: _isMenuVisible
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                            color: const Color(0xfffbf5eb),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildMenuItem("Cosy areas", _selectedOption == "Cosy areas", iconDate[0]),
                              _buildMenuItem("Price", _selectedOption == "Price", iconDate[1]),
                              _buildMenuItem("Infrastructure", _selectedOption == "Infrastructure", iconDate[2]),
                              _buildMenuItem("Without any layer", _selectedOption == "Without any layer", iconDate[3]),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createPositionedContainer(double left, double top) {
    return Positioned(
      left: left,
      top: top,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: Container(
              width: scale == 1.0 ? (_selectedOption == "Price" ? 80 : 50) : 80,
              height: 50,
              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 9),
              decoration: const BoxDecoration(
                color: Color(0xfffcb117),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: scale == 1.0
                  ? _selectedOption == "Price"
                      ? const Text(
                          "10,3 mn P",
                          style: TextStyle(
                            fontFamily: "Euclid Circular A",
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        )
                      : const Icon(
                          Icons.apartment,
                          color: Colors.white,
                        )
                  : const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(String title, bool isSelected, IconData iconData) {
    return InkWell(
      onTap: () {
        _selectOption(title);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(iconData,
                color: isSelected ? const Color(0xfffcb117) : const Color(0xff8c8984)),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: TextStyle(
                fontFamily: "Euclid Circular A",
                fontSize: 15,
                color: isSelected ? const Color(0xfffcb117) : const Color(0xff8c8984),
              ),
            ),
          ],
        ),
      ),
    );
  }

  var iconDate = [
    Icons.shield_outlined,
    Icons.wallet_outlined,
    Icons.apartment,
    Icons.layers,
  ];
}
