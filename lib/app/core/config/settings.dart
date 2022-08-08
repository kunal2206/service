// ignore_for_file: constant_identifier_names

const googleMapURI = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
const nodeBackendURI = 'https://fixpals-backend.herokuapp.com';
const flaskBackendURI = 'https://fixpals-public-backend.herokuapp.com/';
const WEBSOCKETURI = 'ws://spark-orders.herokuapp.com/order?userId';

const LOGIN = "$nodeBackendURI/userLogin";
const WORK_LOGIN = "$nodeBackendURI/serviceman/worklogin";

const VALIDATE_OTP = "$nodeBackendURI/validateOTP";
const ALL_BANNERS = "$flaskBackendURI/banners";
const ALL_CATEGORIES = "$flaskBackendURI/categories";
const SUBCATEGORY_BY_ID = "$flaskBackendURI/subcategory/";
const SERVICE_BY_ID = "$flaskBackendURI/service/";
const POPULAR_SERVICES = "$flaskBackendURI/popular_services";
const SEARCH_PRODUCTS = "$flaskBackendURI/services";
const ADD_ADDRESS = "$flaskBackendURI/address";
const UPDATE_ADDRESS = "$flaskBackendURI/address";
const USER_BY_PHONENUMBER = "$flaskBackendURI/user";
const UPDATE_USER = "$flaskBackendURI/user";
const ADD_ORDER = "$flaskBackendURI/order";
const DELETE_ORDER = "$flaskBackendURI/order";
const ORDER_BY_USER_ID = "$flaskBackendURI/order/user/";
const FIND_SERVICEMAN = "$nodeBackendURI/findServiceman";

const ORDER_BY_ID = "$flaskBackendURI/order";
