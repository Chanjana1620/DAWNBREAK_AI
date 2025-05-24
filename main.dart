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
      Navigator.push(
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
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username or Phone Number'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
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
            onPaymentSuccess: () {
              // This is called after ticket is generated, so just reset fields
              setState(() {
                _boarding = null;
                _destination = null;
                _selectedIndex = 4; // Search tab
              });
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

  List<Widget> _screens() => [
        const Center(child: Text('Cart Page')),
        const Center(child: Text('Payment History')),
        Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('Booking History'),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: () {}, child: const Text('Rebook'))
        ])),
        ProfileDetailsPage(
          name: widget.name,
          age: widget.age,
          dob: widget.dob,
          email: widget.email,
          gender: widget.gender,
        ),
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
              Center(
                child: ElevatedButton(
                  onPressed: _bookTicket,
                  child: const Text('Book Ticket'),
                ),
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProfileDetailsPage(
              name: widget.name,
              age: widget.age,
              dob: widget.dob,
              email: widget.email,
              gender: widget.gender,
            ),
          ),
        );
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
  final VoidCallback onPaymentSuccess;

  PaymentPage({
    required this.boarding,
    required this.destination,
    required this.name,
    required this.age,
    required this.dob,
    required this.onPaymentSuccess,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

enum PaymentMethod { upi, qr, netBanking }

class _PaymentPageState extends State<PaymentPage> {
  PaymentMethod? _selectedMethod;
  bool _isProcessing = false;

  double getFare() {
    // Simple fare calculation based on the index difference in the destination list * 50
    // Use a consistent list for both boarding and destination.
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
    // Dummy time estimate
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
    await Future.delayed(const Duration(seconds: 2)); // simulate payment processing
    setState(() => _isProcessing = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => TicketPage(
          boarding: widget.boarding,
          destination: widget.destination,
          name: widget.name,
          age: widget.age,
          dob: widget.dob,
          seatNumber: Random().nextInt(50) + 1,
          time: getEstimatedTime(),
          price: getFare(),
        ),
      ),
    );

    // onPaymentSuccess should only be called after the ticket has been generated (i.e. after TicketPage is popped back).
    // So, do not call here. Let MainInterface reset fields on return.
    // However, if you want to reset immediately, you may use:
    // WidgetsBinding.instance.addPostFrameCallback((_) => widget.onPaymentSuccess());
    // But usually it is better to do so on return to main interface.
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

  TicketPage({
    required this.boarding,
    required this.destination,
    required this.name,
    required this.age,
    required this.dob,
    required this.seatNumber,
    required this.time,
    required this.price,
  });

  Future<void> _generatePdf(BuildContext context) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('JUZZ TRIP - Travel Ticket',
                        style: pw.TextStyle(
                            fontSize: 24, fontWeight: pw.FontWeight.bold)),
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
                    pw.Text(
                        'Thank you for choosing JUZZ TRIP! Have a safe journey.',
                        style: const pw.TextStyle(fontStyle: pw.FontStyle.italic)),
                  ]),
            );
          }),
    );
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          ],
        ),
      ),
    );
  }
}
