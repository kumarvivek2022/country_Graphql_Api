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
    code
    name
   
    }
  }
''';

Future<List<Countryx>> getAllCountries() async {
  var result = await client.query(
    QueryOptions(

      document: gql(_getAllCountries),
    ),
  );

  var json = result.data!["countries"];
  List<Countryx> countries = [];
  for (var res in json) {
    var countryx = Countryx.fromJson(res);
    countries.add(countryx);
  }
  return countries;
}
Future<Countryx> getCountry(String code) async {
  var result = await client.query(
    QueryOptions(
      document: gql(_getCountry),
      variables: {
        "code": code,
      },
    ),
  );

  var json = result.data!["country"];


  var country = Countryx.fromJson(json);
  return country;
}