import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom_dist_dashboard/consts/colors.dart';
import 'package:my_kom_dist_dashboard/consts/order_status.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/response/search_order_response.dart';
import 'package:my_kom_dist_dashboard/module_orders/model/order_model.dart';
import 'package:my_kom_dist_dashboard/module_orders/state_manager/delivery_orders_bloc.dart';
import 'package:my_kom_dist_dashboard/module_orders/ui/screens/order_detail.dart';

class ALlOrdersScreen extends StatefulWidget {
  ALlOrdersScreen({Key? key}) : super(key: key);

  @override
  State<ALlOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<ALlOrdersScreen>
    with SingleTickerProviderStateMixin {
  final CaptainOrdersListBloc _ordersListBloc = CaptainOrdersListBloc();
  final ScrollController controller = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.clear();
    controller.addListener(_scrollListener);
    _ordersListBloc.getAllOrders(_filter);
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      _ordersListBloc.fetchNextOrders(_filter);
    }
  }

  bool isSearch = false;
  List<String> consts = ['INIT', 'ERROR', 'NOT_FOUND', 'FOUND'];
  String buildResultWidget = 'INIT';
  late OrderModel orderModelSearchResponse;

  _search() async {
    setState(() {
      isSearch = !isSearch;
    });
    await Future.delayed(Duration(seconds: 2));
    int _orderNumber = int.parse(_searchController.text.trim());
    SearchOrderResponse response = await _ordersListBloc.search(_orderNumber);
    if (response.message == null) {
      buildResultWidget = 'ERROR';
    } else if (response.message!) {
      buildResultWidget = 'FOUND';
      orderModelSearchResponse = response.orderModel!;
    } else {
      buildResultWidget = 'NOT_FOUND';
    }
    isSearch = !isSearch;
    setState(() {});
  }

  OrderStatus? _filter = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        title: Text('All Orders',style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Column(
          children: [

            SizedBox(
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                child: TextFormField(
                  controller: _searchController,
                  onChanged: (v) {
                    if (v.isEmpty) {
                      buildResultWidget = 'INIT';
                      setState(() {});
                    }
                  },
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(12),
                      border: OutlineInputBorder(),
                      prefixIconConstraints:
                          BoxConstraints(minHeight: 30, minWidth: 30),
                      hintText: 'Enter Order Number',
                      prefixIcon: SizedBox(
                        height: 2,
                        child: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              if(_searchController.text.trim().isNotEmpty)
                              _search();
                            }),
                      )),
                ),
              ),
            ),
            if (buildResultWidget == 'FOUND')
              Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Text(
                      'Search Result',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  buildSearchResult(orderModelSearchResponse),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 2,
                    height: 3,
                  )
                ],
              ),
            if (buildResultWidget == 'NOT_FOUND')
              Center(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Text('Order Not Found !!!!!!'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 2,
                      height: 3,
                    )
                  ],
                ),
              ),
            if (buildResultWidget == 'ERROR')
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Text('ERROR !!!!!!'),
                ),
              ),
            if (isSearch)
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: ColorsConst.mainColor,
                  ),
                ),
              ),
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 150,
                child: DropdownButtonFormField<OrderStatus?>(
                    icon: Icon(Icons.filter_list_outlined),
                    value: _filter,
                    items: [
                      DropdownMenuItem(
                          value: null,
                          child: Container(
                            child: Text('All'),
                          )),
                      DropdownMenuItem(
                          value: OrderStatus.INIT,
                          child: Container(
                            child: Text('Initail'),
                          )),
                      DropdownMenuItem(
                          value: OrderStatus.GOT_CAPTAIN,
                          child: Container(
                            child: Text('Received'),
                          )),
                      DropdownMenuItem(
                          value: OrderStatus.IN_STORE,
                          child: Container(
                            child: Text('In Store'),
                          )),
                      DropdownMenuItem(
                          value: OrderStatus.DELIVERING,
                          child: Container(
                            child: Text('Delivery'),
                          )),
                      DropdownMenuItem(
                          value: OrderStatus.DONE,
                          child: Container(
                            child: Text('Finished'),
                          ))
                    ],
                    onChanged: (filter) {
                      setState(() {
                        _filter = filter;
                      });
                      _ordersListBloc.getAllOrders(_filter);
                    }),
              ),
            ),
            Expanded(
                child:
                    BlocBuilder<CaptainOrdersListBloc, CaptainOrdersListStates>(
                        bloc: _ordersListBloc,
                        builder: (context, state) {
                          if (state is CaptainOrdersListErrorState) {
                            return Center(
                              child: Text(
                                  'Error In Fetch Data !!  Scroll For Refresh'),
                            );
                          } else if (state is CaptainOrdersListSuccessState) {
                            List<OrderModel> list = state.data['all']!;
                            return _buildOrderList(list);
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }))
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(List<OrderModel> list) {
    return RefreshIndicator(
      onRefresh: () => onRefreshMyOrder(),
      child: ListView.separated(
        itemCount: list.length,
        controller: controller,
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 8,
          );
        },
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          OrderDetailScreen(orderID: list[index].id)));
            },
            child: Container(
              height: 120,
              width: double.infinity,
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 2, spreadRadius: 1)
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: ColorsConst.mainColor.withOpacity(0.1)),
                        child: Text(
                          'Num : ' + list[index].customerOrderID.toString(),
                          style: GoogleFonts.lato(
                              color: ColorsConst.mainColor,
                              fontSize: 15,
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(list[index].description,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                          fontSize: 12,
                          color: Colors.black45,
                          fontWeight: FontWeight.w800)),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.black45,
                      ),
                      Expanded(
                        child: Text(list[index].addressName,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              color: Colors.black45,
                              fontWeight: FontWeight.w800,
                            )),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(list[index].status.toString()),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSearchResult(OrderModel order) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderDetailScreen(orderID: order.id)));
      },
      child: Container(
        height: 120,
        width: double.infinity,
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 2, spreadRadius: 1)
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: ColorsConst.mainColor.withOpacity(0.1)),
                  child: Text(
                    'Num : ' + order.customerOrderID.toString(),
                    style: GoogleFonts.lato(
                        color: ColorsConst.mainColor,
                        fontSize: 15,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold),
                  ),
                ),

              ],
            ),
            SizedBox(
              height: 8,
            ),
            Text(order.description,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                    fontSize: 12,
                    color: Colors.black45,
                    fontWeight: FontWeight.w800)),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.black45,
                ),
                Expanded(
                  child: Text(order.addressName,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        color: Colors.black45,
                        fontWeight: FontWeight.w800,
                      )),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(order.status.toString()),
            )
          ],
        ),
      ),
    );
  }

  Future<void> onRefreshMyOrder() async {}
}
