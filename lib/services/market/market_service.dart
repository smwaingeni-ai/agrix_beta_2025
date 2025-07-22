// /lib/services/market/market_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agrix_beta_2025/models/market/market_item.dart';
import 'package:agrix_beta_2025/models/investments/investment_offer.dart';

/// 📦 MarketService handles local storage for Market Items & Investment Offers
class MarketService {
  static const String _itemsKey = 'market_items';
  static const String _offersKey = 'investment_offers';

  // ================================
  // 📦 MARKET ITEM METHODS
  // ================================

  static Future<List<MarketItem>> loadItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_itemsKey);
      if (raw == null || raw.isEmpty) return [];
      return MarketItem.decodeList(raw);
    } catch (e) {
      print('❌ Error loading market items: $e');
      return [];
    }
  }

  static Future<void> saveItems(List<MarketItem> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = MarketItem.encodeList(items);
      await prefs.setString(_itemsKey, jsonStr);
    } catch (e) {
      print('❌ Error saving market items: $e');
    }
  }

  static Future<void> addItem(MarketItem item) async {
    final items = await loadItems();
    if (!items.any((existing) => existing.id == item.id)) {
      items.add(item);
      await saveItems(items);
    }
  }

  static Future<void> saveItem(MarketItem item) async {
    final items = await loadItems();
    final updated = items.where((e) => e.id != item.id).toList()..add(item);
    await saveItems(updated);
  }

  static Future<void> updateItem(MarketItem updatedItem) async {
    final items = await loadItems();
    final index = items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      items[index] = updatedItem;
      await saveItems(items);
    }
  }

  // ================================
  // 💸 INVESTMENT OFFER METHODS
  // ================================

  static Future<List<InvestmentOffer>> loadOffers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_offersKey);
      if (raw == null || raw.isEmpty) return [];
      return (jsonDecode(raw) as List)
          .map((e) => InvestmentOffer.fromJson(e))
          .toList();
    } catch (e) {
      print('❌ Error loading investment offers: $e');
      return [];
    }
  }

  static Future<void> saveOffers(List<InvestmentOffer> offers) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(offers.map((e) => e.toJson()).toList());
      await prefs.setString(_offersKey, jsonStr);
    } catch (e) {
      print('❌ Error saving investment offers: $e');
    }
  }

  static Future<void> addOffer(InvestmentOffer offer) async {
    final offers = await loadOffers();
    if (!offers.any((existing) => existing.id == offer.id)) {
      offers.add(offer);
      await saveOffers(offers);
    }
  }

  static Future<void> saveOffer(InvestmentOffer offer) async {
    final offers = await loadOffers();
    final updated = offers.where((e) => e.id != offer.id).toList()..add(offer);
    await saveOffers(updated);
  }

  static Future<void> updateOffer(InvestmentOffer updatedOffer) async {
    final offers = await loadOffers();
    final index = offers.indexWhere((e) => e.id == updatedOffer.id);
    if (index != -1) {
      offers[index] = updatedOffer;
      await saveOffers(offers);
    }
  }
}
