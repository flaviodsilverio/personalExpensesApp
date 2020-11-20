import 'package:expenses_app/widgets/new_transaction.dart';
import 'package:expenses_app/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'models/transaction.dart';
import 'package:expenses_app/widgets/chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Personal Expenses",
      theme: ThemeData( 
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: "Quicksand",
        textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: "OpenSans", 
              fontSize: 18, 
              fontWeight: FontWeight.bold
              ),
              button: TextStyle(color: Colors.white)
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: "OpenSans", 
              fontSize: 20, 
              fontWeight: FontWeight.bold)
            )
          )
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // String titleInput;
  // String amountInput;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 final List<Transaction> _userTransactions = [];

 List<Transaction> get _recentTransactions {
   return _userTransactions.where((element) {
     return element.date.isAfter(
       DateTime.now().subtract(
         Duration(days: 7))
       );
   }).toList();
 }

  void _addNewTransaction(String title, double amount, DateTime chosenDate){
    final newTransaction = Transaction(
      amount: amount, 
      title: title, 
      id: DateTime.now().toString(), 
    date: chosenDate);

    setState(() {
      _userTransactions.add(newTransaction);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx, 
      builder: (builderContext) {
        return NewTransaction(_addNewTransaction);
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) {
        return element.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Personal Expenses", style: TextStyle(fontFamily: "OpenSans"),),
        actions: [
          IconButton(icon: 
          Icon(Icons.add), 
          onPressed: () => _startAddNewTransaction(context))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Chart(_recentTransactions),
            TransactionList(_userTransactions, _deleteTransaction),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add), 
        onPressed: () => _startAddNewTransaction(context),),
    );
  }
}
