import 'dart:convert';

import 'package:flutter/foundation.dart';


import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';



import 'package:http/http.dart' as http;
import 'package:image_network/image_network.dart';

import '../../shared/components/item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool load=false;
  List pokemonItems=[];
  Future getData ()async{
    setState(() {
      load=true;
    });
    final response = await http.get(Uri.parse('https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json'));
    var responsebody=jsonDecode(response.body);
    var pokemonList=responsebody['pokemon'];
    setState(() {
      pokemonItems.addAll(pokemonList);
      load=false;
    });
    return pokemonItems;
  }
  @override
  void initState() {
getData();
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        centerTitle: true,
        title: Text('Poke App'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            pokemonItems.clear();
            getData();
          });
        },
        child: const Icon(Icons.repeat_on_outlined),
      ),

      body:load?Center(child:CircularProgressIndicator() ,): Center(
        child:FutureBuilder(future:getData() ,
            builder:(context, snapshot) {
              if (snapshot.hasData){
                return GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  children: pokemonItems.map((pokemon) {
                    return Item(
                      name: pokemon['name'],
                      imgUrl: pokemon['img'],
                    );
                  }).toList());
              }else if (snapshot.hasError){
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },

        )


      ),

    );
  }

  


}
class Item extends StatelessWidget {
  final String name;
  final String imgUrl;
  const Item( {
    required this.name,
    required this.imgUrl,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child:
        Column(
          children: [
            CachedNetworkImage(imageUrl: imgUrl, height: 140, width: 140,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),),
            SizedBox(height: 1,),
            Text(name,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}
