import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/colors.dart';
import '../../../core/bluetooth/bluetooth_service.dart';
import '../../../core/practice/daily_plan_generator.dart';
import '../../../core/providers/app_providers.dart';

class DailyPlanCard extends ConsumerWidget {
  const DailyPlanCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProfileProvider).value;
    final completedModules = profile?.totalModulesCompleted ?? 0;
    final plan = DailyPlanGenerator.generatePlan(
      userId: profile?.id ?? '',
      completedModules: completedModules,
    );
    final btService = ref.watch(bluetoothServiceProvider);
    final isConnected = btService.currentState.isConnected;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                const Text('Dein Plan für heute',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                Text('${plan.totalMinutes} Min',
                    style: const TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(plan.motivationalMessage,
                style: const TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isConnected
                        ? AppColors.success.withOpacity(0.15)
                        : Colors.orange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isConnected ? 'XMARI bereit ✓' : 'XMARI anschließen',
                    style: TextStyle(
                      fontSize: 12,
                      color: isConnected ? AppColors.success : Colors.orange,
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => context.push('/home/daily-plan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Jetzt starten',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
