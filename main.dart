import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() => runApp(JuzzTripApp());

class JuzzTripApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JUZZ TRIP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.red[50],
      ),
      home: LoginPage(),
    );
  }
}

// LOGIN PAGE
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    if (_usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => ProfileSetupPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter both username and password")));
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.redAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.directions_bus, size: 100, color: Colors.white),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username or Phone Number',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// PROFILE SETUP PAGE
class ProfileSetupPage extends StatefulWidget {
  @override
  _ProfileSetupPageState createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String gender = 'Male';

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    dobController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setup Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name')),
            TextField(
                controller: ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number),
            TextField(
                controller: dobController,
                decoration: const InputDecoration(labelText: 'Date of Birth (dd/mm/yyyy)')),
            TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: gender,
              onChanged: (val) {
                if (val != null) {
                  setState(() => gender = val);
                }
              },
              items: ['Male', 'Female', 'Other']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter your name')));
                  return;
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MainInterface(
                      name: nameController.text.trim(),
                      age: ageController.text.trim(),
                      dob: dobController.text.trim(),
                      email: emailController.text.trim(),
                      gender: gender,
                    ),
                  ),
                );
              },
              child: const Text('Save & Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

// MAIN INTERFACE
class MainInterface extends StatefulWidget {
  final String name;
  final String age;
  final String dob;
  final String email;
  final String gender;

  MainInterface({
    required this.name,
    required this.age,
    required this.dob,
    required this.email,
    required this.gender,
  });

  @override
  _MainInterfaceState createState() => _MainInterfaceState();
}

class _MainInterfaceState extends State<MainInterface> {
  int _selectedIndex = 4;

  final List<String> _destinations = [
    'Delhi',
    'Mumbai',
    'Chennai',
    'Kolkata',
    'Bangalore',
    'Hyderabad',
    'Ahmedabad',
    'Pune',
    'Jaipur',
    'Surat',
    'Lucknow',
    'Kanpur',
    'Nagpur',
    'Visakhapatnam',
    'Bhopal',
    'Patna',
    'Ludhiana',
    'Agra',
    'Nashik',
    'Vadodara',
    'Amritsar',
    'Ranchi',
    'Coimbatore',
    'Vijayawada',
    'Madurai',
    'Jodhpur',
    'Raipur',
    'Guwahati',
    'Chandigarh',
    'Thiruvananthapuram'
  ];

  final List<String> _quotes = [
    "Travel is the only thing you buy that makes you richer.",
    "Life is short, and the world is wide.",
    "Collect moments, not things.",
    "Travel far enough, you meet yourself.",
    "Wander often, wonder always."
  ];

  String? _boarding;
  String? _destination;
  late String _selectedQuote;

  // Booking and payment history mock lists
  List<Map<String, dynamic>> bookingHistory = [];
  List<Map<String, dynamic>> paymentHistory = [];
  List<Map<String, dynamic>> cart = [];

  @override
  void initState() {
    super.initState();
    _selectedQuote = _quotes[Random().nextInt(_quotes.length)];
  }

  void _bookTicket() {
    if (_boarding != null &&
        _destination != null &&
        _boarding != _destination) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentPage(
            boarding: _boarding!,
            destination: _destination!,
            name: widget.name,
            age: widget.age,
            dob: widget.dob,
            onPaymentSuccess: (paymentDetail, bookingDetail) {
              setState(() {
                paymentHistory.add(paymentDetail);
                bookingHistory.add(bookingDetail);
                _boarding = null;
                _destination = null;
                _selectedIndex = 4; // Search tab
              });
            },
            onBackToHome: () {
              setState(() {
                _boarding = null;
                _destination = null;
                _selectedIndex = 4;
              });
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select valid boarding and destination")),
      );
    }
  }

  void _addToCart() {
    if (_boarding != null &&
        _destination != null &&
        _boarding != _destination) {
      setState(() {
        cart.add({
          'boarding': _boarding!,
          'destination': _destination!,
        });
        _boarding = null;
        _destination = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Added to cart")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select valid boarding and destination")),
      );
    }
  }

  List<Widget> _screens() => [
        // Cart
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: cart.isEmpty
              ? const Center(child: Text('Cart is empty'))
              : ListView.builder(
                  itemCount: cart.length,
                  itemBuilder: (context, i) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.directions_bus),
                      title: Text(
                          '${cart[i]['boarding']} → ${cart[i]['destination']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() => cart.removeAt(i));
                        },
                      ),
                    ),
                  ),
                ),
        ),
        // Payment History
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: paymentHistory.isEmpty
              ? const Center(child: Text('No payment history'))
              : ListView.builder(
                  itemCount: paymentHistory.length,
                  itemBuilder: (context, i) {
                    final p = paymentHistory[i];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.payment),
                        title: Text(
                            '${p['boarding']} → ${p['destination']}'),
                        subtitle: Text(
                            '₹${p['fare']} | ${p['method']} | ${p['date']}'),
                      ),
                    );
                  },
                ),
        ),
        // Booking History
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: bookingHistory.isEmpty
              ? const Center(child: Text('No booking history'))
              : ListView.builder(
                  itemCount: bookingHistory.length,
                  itemBuilder: (context, i) {
                    final b = bookingHistory[i];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.history),
                        title: Text(
                            '${b['boarding']} → ${b['destination']} (Seat: ${b['seat']})'),
                        subtitle: Text(
                            '${b['date']} | ₹${b['fare']}'),
                        trailing: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _boarding = b['boarding'];
                              _destination = b['destination'];
                              _selectedIndex = 4;
                            });
                          },
                          child: const Text('Rebook'),
                        ),
                      ),
                    );
                  },
                ),
        ),
        // Profile Details
        ProfileDetailsPage(
          name: widget.name,
          age: widget.age,
          dob: widget.dob,
          email: widget.email,
          gender: widget.gender,
        ),
        // Search/Book
        SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_selectedQuote,
                  style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
              const SizedBox(height: 20),
              DropdownButton<String>(
                hint: const Text('Select Boarding Point'),
                value: _boarding,
                isExpanded: true,
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _boarding = val;
                    });
                  }
                },
                items: _destinations
                    .map((dest) => DropdownMenuItem(
                          value: dest,
                          child: Text(dest),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                hint: const Text('Select Destination'),
                value: _destination,
                isExpanded: true,
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _destination = val;
                    });
                  }
                },
                items: _destinations
                    .map((dest) => DropdownMenuItem(
                          value: dest,
                          child: Text(dest),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _bookTicket,
                    child: const Text('Book Ticket'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _addToCart,
                    child: const Text('Add to Cart'),
                  ),
                ],
              )
            ],
          ),
        ),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onDrawerSelect(String item) {
    Navigator.pop(context); // close drawer
    switch (item) {
      case 'Home':
        setState(() => _selectedIndex = 4);
        break;
      case 'Profile Details':
        setState(() => _selectedIndex = 3);
        break;
      case 'Booking History':
        setState(() => _selectedIndex = 2);
        break;
      case 'Payment History':
        setState(() => _selectedIndex = 1);
        break;
      case 'Cart':
        setState(() => _selectedIndex = 0);
        break;
      case 'Logout':
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => LoginPage()), (route) => false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JUZZ TRIP'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.name),
              accountEmail: Text(widget.email.isNotEmpty ? widget.email : 'No email'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(widget.name.isNotEmpty ? widget.name[0] : '',
                    style: const TextStyle(fontSize: 40, color: Colors.red)),
              ),
              decoration: const BoxDecoration(color: Colors.red),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => _onDrawerSelect('Home'),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile Details'),
              onTap: () => _onDrawerSelect('Profile Details'),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Booking History'),
              onTap: () => _onDrawerSelect('Booking History'),
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Payment History'),
              onTap: () => _onDrawerSelect('Payment History'),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Cart'),
              onTap: () => _onDrawerSelect('Cart'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => _onDrawerSelect('Logout'),
            ),
          ],
        ),
      ),
      body: _screens()[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Payments'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        ],
      ),
    );
  }
}

// PROFILE DETAILS PAGE
class ProfileDetailsPage extends StatelessWidget {
  final String name;
  final String age;
  final String dob;
  final String email;
  final String gender;

  const ProfileDetailsPage({
    Key? key,
    required this.name,
    required this.age,
    required this.dob,
    required this.email,
    required this.gender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Details')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(name),
              subtitle: const Text('Name'),
            ),
            ListTile(
              leading: const Icon(Icons.cake),
              title: Text(age),
              subtitle: const Text('Age'),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(dob),
              subtitle: const Text('Date of Birth'),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(email.isNotEmpty ? email : 'No email'),
              subtitle: const Text('Email'),
            ),
            ListTile(
              leading: const Icon(Icons.transgender),
              title: Text(gender),
              subtitle: const Text('Gender'),
            ),
          ],
        ),
      ),
    );
  }
}

// PAYMENT PAGE
class PaymentPage extends StatefulWidget {
  final String boarding;
  final String destination;
  final String name;
  final String age;
  final String dob;
  final Function(Map<String, dynamic> paymentDetail, Map<String, dynamic> bookingDetail) onPaymentSuccess;
  final VoidCallback? onBackToHome;

  PaymentPage({
    required this.boarding,
    required this.destination,
    required this.name,
    required this.age,
    required this.dob,
    required this.onPaymentSuccess,
    this.onBackToHome,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

enum PaymentMethod { upi, qr, netBanking }

class _PaymentPageState extends State<PaymentPage> {
  PaymentMethod? _selectedMethod;
  bool _isProcessing = false;

  double getFare() {
    final destinations = [
      'Delhi',
      'Mumbai',
      'Chennai',
      'Kolkata',
      'Bangalore',
      'Hyderabad',
      'Ahmedabad',
      'Pune',
      'Jaipur',
      'Surat',
      'Lucknow',
      'Kanpur',
      'Nagpur',
      'Visakhapatnam',
      'Bhopal',
      'Patna',
      'Ludhiana',
      'Agra',
      'Nashik',
      'Vadodara',
      'Amritsar',
      'Ranchi',
      'Coimbatore',
      'Vijayawada',
      'Madurai',
      'Jodhpur',
      'Raipur',
      'Guwahati',
      'Chandigarh',
      'Thiruvananthapuram'
    ];
    int i1 = destinations.indexOf(widget.boarding);
    int i2 = destinations.indexOf(widget.destination);
    if (i1 == -1 || i2 == -1) return 0;
    return (i2 - i1).abs() * 50.0 + 100; // always at least ₹100
  }

  String getEstimatedTime() {
    return '${2 + Random().nextInt(5)} hours';
  }

  void _pay() async {
    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method')),
      );
      return;
    }

    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isProcessing = false);

    int seatNumber = Random().nextInt(50) + 1;
    String travelTime = getEstimatedTime();
    double fare = getFare();
    String methodStr = _selectedMethod.toString().split('.').last;

    // Payment and Booking Details for history
    final now = DateTime.now();
    Map<String, dynamic> paymentDetail = {
      'boarding': widget.boarding,
      'destination': widget.destination,
      'fare': fare.toStringAsFixed(2),
      'method': methodStr,
      'date': '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}'
    };
    Map<String, dynamic> bookingDetail = {
      'boarding': widget.boarding,
      'destination': widget.destination,
      'seat': seatNumber,
      'fare': fare.toStringAsFixed(2),
      'date': '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}'
    };

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => TicketPage(
          boarding: widget.boarding,
          destination: widget.destination,
          name: widget.name,
          age: widget.age,
          dob: widget.dob,
          seatNumber: seatNumber,
          time: travelTime,
          price: fare,
          onTicketClose: () {
            widget.onPaymentSuccess(paymentDetail, bookingDetail);
            // Use the callback to go back to home if provided, else pop to root.
            if (widget.onBackToHome != null) {
              widget.onBackToHome!();
            } else {
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('From: ${widget.boarding}'),
            Text('To: ${widget.destination}'),
            Text('Estimated time: ${getEstimatedTime()}'),
            Text('Fare: ₹${getFare().toStringAsFixed(2)}'),
            const SizedBox(height: 20),
            const Text('Select Payment Method:', style: TextStyle(fontWeight: FontWeight.bold)),
            RadioListTile<PaymentMethod>(
              title: const Text('UPI'),
              value: PaymentMethod.upi,
              groupValue: _selectedMethod,
              onChanged: (val) => setState(() => _selectedMethod = val),
            ),
            RadioListTile<PaymentMethod>(
              title: const Text('QR Code'),
              value: PaymentMethod.qr,
              groupValue: _selectedMethod,
              onChanged: (val) => setState(() => _selectedMethod = val),
            ),
            RadioListTile<PaymentMethod>(
              title: const Text('Net Banking'),
              value: PaymentMethod.netBanking,
              groupValue: _selectedMethod,
              onChanged: (val) => setState(() => _selectedMethod = val),
            ),
            const SizedBox(height: 30),
            Center(
              child: _isProcessing
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _pay,
                      child: const Text('Pay'),
                    ),
            )
          ],
        ),
      ),
    );
  }
}

// TICKET PAGE WITH PDF GENERATION
class TicketPage extends StatelessWidget {
  final String boarding;
  final String destination;
  final String name;
  final String age;
  final String dob;
  final int seatNumber;
  final String time;
  final double price;
  final VoidCallback onTicketClose;

  TicketPage({
    required this.boarding,
    required this.destination,
    required this.name,
    required this.age,
    required this.dob,
    required this.seatNumber,
    required this.time,
    required this.price,
    required this.onTicketClose,
  });

  Future<void> _generatePdf(BuildContext context) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Container(
                width: 400,
                padding: const pw.EdgeInsets.all(24),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.red, width: 2),
                  borderRadius: pw.BorderRadius.circular(16),
                ),
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Center(
                        child: pw.Text('JUZZ TRIP - Travel Ticket',
                            style: pw.TextStyle(
                                fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.red)),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Text('Name: $name'),
                      pw.Text('Age: $age'),
                      pw.Text('Date of Birth: $dob'),
                      pw.Text('Boarding Point: $boarding'),
                      pw.Text('Destination: $destination'),
                      pw.Text('Seat Number: $seatNumber'),
                      pw.Text('Time of Travel: $time'),
                      pw.Text('Ticket Price: ₹${price.toStringAsFixed(2)}'),
                      pw.SizedBox(height: 20),
                      pw.Center(
                        child: pw.Text(
                            'Thank you for choosing JUZZ TRIP! Have a safe journey.',
                            style: pw.TextStyle(fontStyle: pw.FontStyle.italic, color: PdfColors.red)),
                      ),
                    ]),
              ),
            );
          }),
    );
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onTicketClose();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Ticket'),
          actions: [
            IconButton(
                onPressed: () => _generatePdf(context),
                icon: const Icon(Icons.picture_as_pdf))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(name),
                subtitle: const Text('Name'),
              ),
              ListTile(
                leading: const Icon(Icons.cake),
                title: Text(age),
                subtitle: const Text('Age'),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(dob),
                subtitle: const Text('Date of Birth'),
              ),
              ListTile(
                leading: const Icon(Icons.location_city),
                title: Text(boarding),
                subtitle: const Text('Boarding Point'),
              ),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: Text(destination),
                subtitle: const Text('Destination'),
              ),
              ListTile(
                leading: const Icon(Icons.event_seat),
                title: Text('$seatNumber'),
                subtitle: const Text('Seat Number'),
              ),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: Text(time),
                subtitle: const Text('Time of Travel'),
              ),
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: Text('₹${price.toStringAsFixed(2)}'),
                subtitle: const Text('Ticket Price'),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    onTicketClose();
                  },
                  child: const Text('Back to Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
