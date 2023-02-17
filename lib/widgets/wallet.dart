import 'package:flutter/material.dart';

void main() {
  runApp(
    const App(
      username: "Mr. Choi",
      balance: 1234567890,
    ),
  );
}

String addSpacesToBalance({String? currencyType, required double balance}) {
  String balanceString = balance.toString();
  int length = balanceString.length;
  String result = currencyType == null ? "" : "$currencyType ";

  for (int i = 0; i < length; i++) {
    if (i != 0 && (length - i) % 3 == 0) {
      result += " ";
    }
    result += balanceString[i];
  }
  return result;
}

class App extends StatelessWidget {
  const App({
    super.key,
    required this.username,
    required this.balance,
  });
  final String username;
  final double balance;

  @override
  Widget build(BuildContext context) {
    const double scaleFactor = 0.7;
    const double headerHeight = 100 * scaleFactor;
    const double emptySpaceHeight = 100 * scaleFactor;
    const double bigFontSize = 48 * scaleFactor;
    const double smallFontSize = 24 * scaleFactor;
    const double mediumFontSize = (bigFontSize + smallFontSize) / 2;
    const double menuIconSize = 60 * scaleFactor;
    const double margin = 30 * scaleFactor;
    const double buttonWidth = 200 * scaleFactor;
    const double buttonHeight = 80 * scaleFactor;
    const double buttonRounding = buttonHeight / 2;
    // const double cardOverlap = 20 * scaleFactor;
    // const double cardSpacing =
    // (emptySpaceHeight + headerHeight) / 2 + margin - cardOverlap;
    final List<BalanceCard> allCards = [
      const BalanceCard(
        scaleFactor: scaleFactor,
        margin: margin,
        bigFontSize: bigFontSize,
        mediumFontSize: mediumFontSize,
        smallFontSize: smallFontSize,
        headerHeight: headerHeight,
        emptySpaceHeight: emptySpaceHeight,
        currencyTypeFull: "Dollar",
        currencyTypeShort: "USD",
        currencyIcon: Icons.attach_money,
        balance: 12345,
        isInverted: true,
      ),
      const BalanceCard(
        scaleFactor: scaleFactor,
        margin: margin,
        bigFontSize: bigFontSize,
        mediumFontSize: mediumFontSize,
        smallFontSize: smallFontSize,
        headerHeight: headerHeight,
        emptySpaceHeight: emptySpaceHeight,
        currencyTypeFull: "Bitcoin",
        currencyTypeShort: "BTC",
        currencyIcon: Icons.currency_bitcoin,
        balance: 54321,
      ),
      const BalanceCard(
        scaleFactor: scaleFactor,
        margin: margin,
        bigFontSize: bigFontSize,
        mediumFontSize: mediumFontSize,
        smallFontSize: smallFontSize,
        headerHeight: headerHeight,
        emptySpaceHeight: emptySpaceHeight,
        currencyTypeFull: "Euro",
        currencyTypeShort: "EUR",
        currencyIcon: Icons.euro_rounded,
        balance: 67890,
        isInverted: true,
      ),
    ];
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: margin,
            vertical: margin,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Text(window.size.width.toString()),
              SizedBox(
                height: headerHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => {},
                      iconSize: menuIconSize,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          username,
                          style: const TextStyle(
                              fontSize: bigFontSize,
                              fontWeight: FontWeight.w700),
                        ),
                        const Opacity(
                          opacity: 0.5,
                          child: Text(
                            "Welcome back",
                            style: TextStyle(
                              fontSize: smallFontSize,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: emptySpaceHeight,
              ),
              const Opacity(
                opacity: 0.5,
                child: Text(
                  "Total Balance",
                  style: TextStyle(fontSize: smallFontSize),
                ),
              ),
              Text(
                addSpacesToBalance(currencyType: "\$", balance: balance),
                style: const TextStyle(
                  fontSize: bigFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: margin,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Flexible(
                      flex: 5,
                      child: RoundedButton(
                        buttonHeight: buttonHeight,
                        buttonWidth: buttonWidth,
                        buttonRoundingRadius: buttonRounding,
                        buttonFontSize: smallFontSize,
                        buttonColor: Colors.amber,
                        buttonTextColor: Colors.black,
                        buttonText: "Transfer",
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: SizedBox(),
                    ),
                    Flexible(
                      flex: 5,
                      child: RoundedButton(
                        buttonHeight: buttonHeight,
                        buttonWidth: buttonWidth,
                        buttonRoundingRadius: buttonRounding,
                        buttonFontSize: smallFontSize,
                        buttonColor: Color.fromRGBO(255, 255, 255, 0.1),
                        buttonTextColor: Colors.white,
                        buttonText: "Request",
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: margin,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      "Wallets",
                      style: TextStyle(
                        fontSize: bigFontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Opacity(
                      opacity: 0.5,
                      child: Text(
                        "View All",
                        style: TextStyle(
                          fontSize: smallFontSize,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StackedBalanceCards(
                allCards: allCards,
                scaleFactor: scaleFactor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StackedBalanceCards extends StatelessWidget {
  const StackedBalanceCards({
    super.key,
    required this.scaleFactor,
    required this.allCards,
  });
  final double scaleFactor;
  final List<BalanceCard> allCards;
  @override
  Widget build(BuildContext context) {
    final List allCardsWithOrder = [
      for (var i in [0, 1, 2]) allCards[i]
    ];
    final List<Positioned> allCardsPositioned = [];
    allCardsWithOrder.asMap().forEach(
          (idx, card) => {
            allCardsPositioned.add(
              Positioned(
                child: card,
                top: idx * 110 * scaleFactor,
              ),
            )
          },
        );

    return SizedBox(
      height: 340 * scaleFactor, // adjust the height as needed
      child: Stack(
        alignment: Alignment.topCenter,
        children: allCardsPositioned,
      ),
    );
  }
}

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.scaleFactor,
    required this.margin,
    required this.bigFontSize,
    required this.mediumFontSize,
    required this.smallFontSize,
    required this.headerHeight,
    required this.emptySpaceHeight,
    required this.currencyTypeFull,
    required this.currencyTypeShort,
    required this.currencyIcon,
    required this.balance,
    this.isInverted = false,
  });

  final double scaleFactor;
  final double margin;
  final double bigFontSize;
  final double mediumFontSize;
  final double smallFontSize;
  final double headerHeight;
  final double emptySpaceHeight;
  final String currencyTypeFull;
  final String currencyTypeShort;
  final IconData currencyIcon;
  final double balance;
  final bool isInverted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400 * scaleFactor,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color:
              isInverted ? Colors.white : const Color.fromRGBO(20, 20, 20, 1),
          borderRadius: BorderRadius.all(Radius.circular(30 * scaleFactor))),
      padding: EdgeInsets.fromLTRB(margin, 0, margin, margin / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: margin / 2),
                child: Text(
                  currencyTypeFull,
                  style: TextStyle(
                    color: isInverted ? Colors.black : Colors.white,
                    fontSize: (bigFontSize + mediumFontSize) / 2,
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: margin / 2),
                    child: Opacity(
                      opacity: 0.8,
                      child: Text(
                        addSpacesToBalance(balance: balance),
                        style: TextStyle(
                          color: isInverted ? Colors.black : Colors.white,
                          fontSize: (mediumFontSize + smallFontSize) / 2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: Text(
                      currencyTypeShort,
                      style: TextStyle(
                        color: isInverted ? Colors.black : Colors.white,
                        fontSize: smallFontSize,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          Transform.scale(
            scale: 1.5,
            alignment: Alignment.topLeft,
            child: Icon(
              currencyIcon,
              color: isInverted ? Colors.black : Colors.white,
              size: (headerHeight + emptySpaceHeight) / 2,
            ),
          ),
        ],
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    super.key,
    required this.buttonHeight,
    required this.buttonWidth,
    required this.buttonRoundingRadius,
    required this.buttonFontSize,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.buttonText,
  });

  final double buttonHeight;
  final double buttonWidth;
  final double buttonRoundingRadius;
  final double buttonFontSize;
  final Color buttonColor;
  final Color buttonTextColor;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      width: buttonWidth,
      child: ElevatedButton(
        onPressed: () => {},
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonRoundingRadius),
            ),
          ),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: buttonFontSize,
            color: buttonTextColor,
          ),
        ),
      ),
    );
  }
}
