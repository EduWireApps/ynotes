import 'dart:convert';

import 'package:supabase/supabase.dart';
import 'package:ynotes/core/apis/ecole_directe.dart';

class LvsBetaUtil {
  SupabaseClient? client;
  Token? token;

  Future<bool> isAccessProvided() async {
    try {
      Token? token = await _getToken();
      if (token != null) {
        if (await _tokenExists(token)) {
          return true;
        } else {
          return await _newTokenQuery();
        }
      } else {
        return await _newTokenQuery();
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> _assignToken(Token token) async {
    try {
      final response = await client?.from('tokens').update({"used": true}).eq('id', token.id).execute();
      if (response?.status == 200) {
        await _saveToken(token);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<Token?> _availableTokens() async {
    client = SupabaseClient('https://zjubjybzyyhxgcnicsfp.supabase.co', "%SUPABASEAPIKEY");
    final response = await client?.from('tokens').select().filter('used', 'eq', 'false').execute();
    if (response?.data?.length != 0) {
      return Token(token: response?.data[0]["token"], id: response?.data[0]["id"]);
    }
  }

  Future<Token?> _getToken() async {
    try {
      Token token = jsonDecode(await storage.read(key: "lvstoken") ?? "{}");
      return token;
    } catch (e) {
      return null;
    }
  }

  Future<bool> _newTokenQuery() async {
    try {
      Token? token = await _availableTokens();
      if (token == null) {
        return await _assignToken(token!);
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> _saveToken(Token token) async {
    try {
      createStorage("lvstoken", jsonEncode(token));
      return true;
    } catch (e) {
      return false;
    }
  }

  ///To check if a token exists
  Future<bool> _tokenExists(Token token) async {
    try {
      final response = await client?.from('tokens').select().filter("token", 'eq', token.token).execute();
      if (response?.data?.length != 0 && response?.data[0]["used"] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

class Token {
  final String token;
  final int id;
  Token({required this.token, required this.id});
  factory Token.fromJson(Map<String, dynamic> json) =>
      Token(token: (json['token'] as String?) ?? "", id: (json['id'] as int?) ?? 0);

  Map<String, Object?> toJson() => {'token': token, 'id': id};
}
