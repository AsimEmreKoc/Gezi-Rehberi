// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

List<String> searchResults = [
      'Alanya Kalesi //Antalya',
      'Antalya Hayvanat Bahçesi //Antalya',
      'Aspendos //Antalya',
      'Köprülü Kanyon //Antalya',
      'Manavgat Şelalesi //Antalya',
      'Bursa Hayvanat Bahçesi //Bursa',
      'Bursa Kent Müzesi //Bursa',
      'Koza Han //Bursa',
      'Ulu Cami //Bursa',
      'Uludağ // Bursa',
      'Denizli Kayak Merkezi //Denizli',
      'Hierapolis Arkeoloji Müzesi //Denizli',
      'Karahayit Ağlayan Kaya // Denizli',
      'Laodicea //Denizli',
      'Tripolis Antik Kenti //Denizli',
      'Gaziantep Arkeoloji Müzesi //Gaziantep',
      'Gaziantep Kalesi //Gaziantep',
      'Rumkale //Gaziantep',
      'Zeugma Belkıs Antik Kenti //Gaziantep',
      'Zeugma Mozaik Müzesi // Gaziantep',
      'Dara Mezopotamya Harabeleri //Mardin',
      'Kırklar Kilisesi //Mardin',
      'Mardin Kalesi //Mardin',
      'Mardin Müzesi //Mardin',
      'Saint Hirmiz Chaldean Kilisesi //Mardin',
      'Bodrum Anfi Tiyatrosu //Muğla',
      'Bodrum Kalesi //Muğla',
      'Knidos Antik Kenti //Muğla',
      'Labranda Antik Kenti //Muğla',
      'Saklıkent Milli Parkı //Muğla', 
      'Göre Harabeleri //Nevşehir',
      'Hacı Bektaş Veli Müzesi //Nevşehir',
      'Kapadokya //Nevşehir',
      'Peri Bacaları //Nevşehir',
      'Özkonak Yeraltı Şehri //Nevşehir',
      'Divriği Ulu Cami Darüşşifası //Sivas',
      'Gökpınar Gölü //Sivas',
      'Sivas Kalesi //Sivas',
      'Sızır Şelalesi //Sivas',
      'Çifte Minareli Medrese //Sivas',
      '57. Alay Şehitliği //Çanakkale',
      'Aynalı Çarşı //Çanakkale',
      'Troia Antik Kenti //Çanakkale',
      'Çanakkale Deniz Müzesi //Çanakkale',
      'Çanakkale Şehitler Abidesi //Çanakkale',
      'Ayasofya //İstanbul',
      'Dolmabahçe Sarayı //İstanbul',
      'Galata Kulesi //İstanbul',
      'Topkapı Sarayı //İstanbul',
      'Yerebatan Sarnıcı //İstanbul',
    ];
  