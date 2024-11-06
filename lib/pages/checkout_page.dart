import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:travel_partouche_app/constants/consts.dart';
import 'package:travel_partouche_app/model/app_provider.dart';
import 'package:travel_partouche_app/pages/order_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final Set<Marker> _markers = {};

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _addMarker(LatLng positiion) async {
    final String markerId = _markers.length.toString();
    _markers.clear();
    _markers.add(
      Marker(
        onTap: () {},
        markerId: MarkerId(markerId),
        position: positiion,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select a pickup point",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            SizedBox(height: screenSize.height * 0.01),
            SizedBox(
              height: screenSize.height * 0.4,
              width: screenSize.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: GoogleMap(
                  myLocationButtonEnabled: false,
                  onMapCreated: (GoogleMapController controller) async {
                    _controller.complete(controller);
                  },
                  myLocationEnabled: true,
                  markers: _markers,
                  onTap: (argument) async {
                    await _addMarker(argument);
                  },
                  mapType: MapType.normal,
                  initialCameraPosition: cameraPosition!,
                ),
              ),
            ),
            SizedBox(height: screenSize.height * 0.02),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Select the day of order pickup',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text: selectedDate == null
                        ? ''
                        : '${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _selectTime(context),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Select the time of order pickup',
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  controller: TextEditingController(
                    text: selectedTime == null
                        ? ''
                        : selectedTime!.format(context),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () async {
                final appProvider =
                    Provider.of<AppProvider>(context, listen: false);
                final totalCost = appProvider.calculateTotalCost();

                if (appProvider.coins >= totalCost) {
                  await Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => OrderConfirmationPage(
                        productName: "Keychain 'Eiffel Tower'",
                        address: "Costco Wholesale",
                        date: selectedDate != null
                            ? DateFormat('d MMMM').format(selectedDate!)
                            : 'No date selected',
                        time: selectedTime != null
                            ? '${selectedTime!.hourOfPeriod} ${selectedTime!.period == DayPeriod.am ? "a.m." : "p.m."}'
                            : 'No time selected',
                      ),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Insufficient Coins"),
                      content: Text(
                        "You need ${totalCost - appProvider.coins} more coins to complete this order.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Order',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
