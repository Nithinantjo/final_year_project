import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/details.dart';
import 'package:shop/services/api.dart';


class Cards extends StatefulWidget {
  final String name, price, imgpath;
  int count;
  bool added, isFavorite;
  Cards({required this.name,required this.price,required this.imgpath,required this.added,
    required  this.isFavorite, required this.count, context, super.key,});

  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {

  int _counter =0;
  @override
  void initState(){
    _counter= widget.count;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    String Name = "";
    if(widget.name.length<12){
      Name = widget.name;
    }
    else{
      Name = widget.name.substring(0,8) + "...";
    }
    return Padding(
          padding:
              const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
          child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Detail(
                          assetPath: widget.imgpath,
                          price: widget.price,
                          name: widget.name,
                          count: _counter,
                          isadded: widget.added,
                        )));
              },
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 3.0,
                            blurRadius: 5.0)
                      ],
                      color: Colors.white),
                  child: Column(children: [
                    Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              widget.isFavorite
                                  ? const Icon(Icons.favorite,
                                      color: Color(0xFFEF7532))
                                  : const Icon(Icons.favorite_border,
                                      color: Color(0xFFEF7532))
                            ])),
                    Hero(
                        tag: widget.name,
                        child: Container(
                            height: 75.0,
                            width: 75.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(widget.imgpath),
                                    fit: BoxFit.contain)))),
                    const SizedBox(height: 15.0),
                    Text('Rs. ${widget.price}',
                        style: const TextStyle(
                            color: Color(0xFFCC8053),
                            fontFamily: 'Varela',
                            fontSize: 16.0)),
                    Text(Name,
                        style: const TextStyle(
                            color: Color(0xFF575E67),
                            fontFamily: 'Varela',
                            fontSize: 16.0)),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Container(color: const Color(0xFFEBEBEB), height: 1.0)),
                    Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (!widget.added) ...[
                                const Icon(Icons.shopping_basket,
                                    color: Color(0xFFD17E50), size: 18.0),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      widget.added = true;
                                    });
                                    add();
                                  },
                                  child: const Text('Add to cart',
                                      style: TextStyle(
                                          fontFamily: 'Varela',
                                          color: Color(0xFFD17E50),
                                          fontSize: 18.0)),
                                )
                              ],
                              if (widget.added) ...[
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if(_counter>1)
                                      {_counter--;}
                                    else if(_counter==1)
                                      {widget.added=false;}
                                    });
                                    decre();
                                  },
                                  icon: const Icon(Icons.remove_circle_outline,
                                      color: Color(0xFFD17E50), size: 20.0),
                                ),
                                Text('$_counter',
                                        style: const TextStyle(
                                            fontFamily: 'Varela',
                                            color: Color(0xFFD17E50),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0))
                                  ,
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _counter++;
                                    });
                                    incre();
                                  },
                                  icon: const Icon(Icons.add_circle_outline,
                                      color: Color(0xFFD17E50), size: 20.0),
                                ),
                              ]
                            ]))
                  ]))));
  }
  void incre() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    String? email = sharedPrefs.getString("email");
    if(email!=null){
      APIService.increment(email, widget.name);
    }
  }

  void decre() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    String? email = sharedPrefs.getString("email");
    if(email!=null){
      APIService.decrement(email, widget.name);
    }
  }

  void add() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    String? email = sharedPrefs.getString("email");
    if(email!=null){
      APIService.addCart(email, widget.name);
    }
  }
}