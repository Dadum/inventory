import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inventory/constants.dart';
import 'package:inventory/providers/api.dart';

class ItemWidget extends ConsumerWidget {
  final Item item;

  const ItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
        future: ref
            .watch(itemDetailsProvider.selectAsync((value) => value[item.id])),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final details = snapshot.data!;

          return Tooltip(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8.0),
            ),
            richMessage: WidgetSpan(
              child: ItemTooltip(details: details),
            ),
            child: InkWell(
              onTap: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Copied to clipboard'),
                    behavior: SnackBarBehavior.floating,
                    width: 200,
                  ),
                );
                await Clipboard.setData(ClipboardData(text: details.chatLink));
              },
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        details.icon,
                        fit: BoxFit.cover,
                        frameBuilder:
                            (context, child, frame, wasSynchronouslyLoaded) {
                          if (frame == null) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          return child.animate().fadeIn(duration: 500.ms);
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding:
                          const EdgeInsets.all(LayoutConstants.smallPadding),
                      child: CountCard(count: item.count),
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 500.ms);
        });
  }
}

class EmptySlots extends StatelessWidget {
  const EmptySlots({
    super.key,
    required this.freeSlots,
  });

  final int freeSlots;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: Card.filled(),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(LayoutConstants.smallPadding),
            child: CountCard(count: freeSlots),
          ),
        )
      ],
    );
  }
}

class CountCard extends StatelessWidget {
  final int count;

  const CountCard({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 34,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            '$count',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ),
    );
  }
}

class ItemTooltip extends StatelessWidget {
  final Details details;

  const ItemTooltip({
    super.key,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 350),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            details.name,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.apply(color: details.rarity.color),
          ),
          if (details.description != null ||
              details.details?.description != null) ...[
            const SizedBox.square(
              dimension: LayoutConstants.mediumPadding,
            ),
            HtmlWidget(
                details.description ?? details.details?.description ?? ''),
          ],
          if (details.flags.isNotEmpty) ...[
            const SizedBox.square(
              dimension: LayoutConstants.mediumPadding,
            ),
            Text(details.flags.toString()),
          ],
          const SizedBox.square(
            dimension: LayoutConstants.mediumPadding,
          ),
          Text(details.details?.type ?? details.type),
          const SizedBox.square(
            dimension: LayoutConstants.mediumPadding,
          ),
          VendorValue(value: details.vendorValue),
        ],
      ),
    );
  }
}

class VendorValue extends StatelessWidget {
  const VendorValue({super.key, required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Vendor value: ',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (value > 10000) ...[
            TextSpan(
              text: '${value ~/ 10000}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            WidgetSpan(
              alignment: PlaceholderAlignment.bottom,
              child: Padding(
                padding: const EdgeInsets.all(LayoutConstants.smallPadding),
                child: SizedBox.square(
                  dimension: Theme.of(context).textTheme.bodySmall?.fontSize,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFC813),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            const TextSpan(text: ' '),
          ],
          if (value > 100) ...[
            TextSpan(
              text: '${(value % 10000) ~/ 100}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            WidgetSpan(
              alignment: PlaceholderAlignment.bottom,
              child: Padding(
                padding: const EdgeInsets.all(LayoutConstants.smallPadding),
                child: SizedBox.square(
                  dimension: Theme.of(context).textTheme.bodySmall?.fontSize,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xffc0c0c0),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            const TextSpan(text: ' '),
          ],
          TextSpan(
            text: '${value % 100}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          // copper colored circle
          WidgetSpan(
            alignment: PlaceholderAlignment.bottom,
            child: Padding(
              padding: const EdgeInsets.all(LayoutConstants.smallPadding),
              child: SizedBox.square(
                dimension: Theme.of(context).textTheme.bodySmall?.fontSize,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xffb87333),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
