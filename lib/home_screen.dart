import 'package:flutter/material.dart';
import 'package:th_platform_channel_demo/health_service.dart';
import 'package:intl/intl.dart';
import 'package:th_platform_channel_demo/step_record.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<StepRecord> _stepsData = [];
  bool _loading = false;

  Future<void> _syncSteps() async {
    setState(() => _loading = true);
    final isAuthorized = await HealthService.requestAuthorization();
    if (!isAuthorized) {
      setState(() => _loading = false);
      return;
    }
    final double? stepValue = await HealthService.getSteps();
    if (stepValue == null) {
      setState(() => _loading = false);
      return;
    }
    final today = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final idx = _stepsData.indexWhere((r) => r.date == today);
    setState(() {
      if (idx >= 0) {
        _stepsData[idx] = StepRecord(date: today, stepValue: stepValue);
      } else {
        _stepsData.add(StepRecord(date: today, stepValue: stepValue));
      }
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasData = _stepsData.isNotEmpty;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            actions: [
              IconButton(
                icon: const Icon(Icons.sync),
                onPressed: _syncSteps,
                tooltip: 'Sync',
              ),
            ],
          ),
          body: hasData
              ? ListView.separated(
                  itemCount: _stepsData.length + 1,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // Header row
                      return Container(
                        color: Colors.grey[200],
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: Row(
                          children: const [
                            Expanded(
                              child: Text(
                                'Date',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Steps',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    final item = _stepsData[index - 1];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(item.date),
                          ),
                          Expanded(
                            child: Text(
                              item.stepValue.toStringAsFixed(0),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      'There is no data yet, press the Sync button to get data',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
        ),
        if (_loading)
          Container(
            color: Colors.black.withAlpha(50),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
