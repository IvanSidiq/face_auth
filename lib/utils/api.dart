import 'package:flutter_flavor/flutter_flavor.dart';

String kApiKebab =
    FlavorConfig.instance.name == 'LOCAL' ? ':4001/api/v1' : '/kebab/api/v1';
String kApiNogosari =
    FlavorConfig.instance.name == 'LOCAL' ? ':4000/api/v1' : '/nogosari/api/v1';

String type = FlavorConfig.instance.name == 'PRODUCTION'
    ? 'prod'
    : (FlavorConfig.instance.name == 'STAGING' ? 'stg' : 'dev');

String kApiImage = 'https://nogosari-$type.s3.ap-southeast-1.amazonaws.com';
String kApiEbook = 'https://nogosari-$type.s3.ap-southeast-1.amazonaws.com';

//Auth
String kApiLogin = '$kApiNogosari/users/login';
String kApiRegister = '$kApiNogosari/users/register';
String kApiLogout = '$kApiNogosari/users/logout';
String kApiForgotPasswordVerification = '$kApiNogosari/users/forgot-password';
String kApiForgotPasswordOtpVerification =
    '$kApiNogosari/users/forgot-password/confirm';
String kApiForgotPasswordNewPassword =
    '$kApiNogosari/users/forgot-password/change';
String kApiEmailVerification = '$kApiNogosari/email/send-verification';
String kApiEmailChange = '$kApiNogosari/users/email/change';

//Profile
String kApiProfile = '$kApiNogosari/users/profile';
String kApiPassword = '$kApiNogosari/users/password';

//Collection
String kApiCollectionDetail = '$kApiKebab/books';
String kApiRecCollectionList = '$kApiKebab/collections/recommended';
String kApiCollectionList = '$kApiKebab/collections';
String kApiWishlistCollection = '$kApiKebab/wishlists/books';
String kApiAddWishlist = '$kApiKebab/wishlists';
const String kApiTerminateColection = '/borrowers/terminate';
const String kApiExtendCollection = '/borrowers';

//borrow
String kApiBorrowBook = '$kApiKebab/borrowers';

//setting
String kApiSetting = '$kApiKebab/settings';

//school
String kApiSchoolProfileNogosari = '$kApiNogosari/schools/profile';
String kApiSchoolProfile = '$kApiKebab/schools/profile';
String kApiSchoolList = '$kApiNogosari/users/schools';
String kApiSchoolRegistration = '$kApiNogosari/users/subscribe';
String kApiSchoolCodeCheck = '$kApiNogosari/schools/subscribe';

//location
String kApiProvince =
    'https://harisalghifary.github.io/data-indonesia/provinsi.json';
String kApiCity = 'https://harisalghifary.github.io/data-indonesia/kabupaten/';
String kApiDistrict =
    'https://harisalghifary.github.io/data-indonesia/kecamatan/';
