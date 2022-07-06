import 'package:country_directory/model/final_model.dart';
import 'package:graphql/client.dart';

const baseURL = "https://countries.trevorblades.com/graphql";

final _httpLink = HttpLink(
  baseURL,
);
final GraphQLClient client = GraphQLClient(
  link: _httpLink,
  cache: GraphQLCache(),
);

const _getCountry = r'''
query getCountry($code:ID!){
  country(code:$code){
    name
    capital
    code
    native
    currency
    phone
    emoji
    languages {
      code,
      name
    }

  }
}

''';

const _getAllCountries = r'''
query {
  countries{
    code,
    name,
    emoji,
    currency,
    capital,
    languages {
      code,
      name
    }
    }
  }
''';
const getAllLanguage = r'''
query {
 languages {
    code
    name 
   }
  }
''';

Future<List<Country>> getAllCountries() async {
  var result = await client.query(
    QueryOptions(

      document: gql(_getAllCountries),
    ),
  );

  var json = result.data!["countries"];
  List<Country> countries = [];
  for (var res in json) {
    var country = Country.fromJson(res);
    countries.add(country);
  }
  return countries;
}
Future<Country> getCountry(String code) async {
  var result = await client.query(
    QueryOptions(
      document: gql(_getCountry),
      variables: {
        "code": code,
      },
    ),
  );

  var json = result.data!["country"];


  var country = Country.fromJson(json);
  return country;
}

Future<List<Languages>> getAllLanguages() async {
  var result = await client.query(
    QueryOptions(
      document: gql(getAllLanguage),
    ),
  );
  if (result.hasException) {
    throw result.exception!;
  }
  var json = result.data!["languages"];
  List<Languages> lang = [];
  for (var res in json) {
    var languages = Languages.fromJson(res);
    lang.add(languages);
  }
  return lang;
}

