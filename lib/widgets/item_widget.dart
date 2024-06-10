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
    final details = ref.watch(itemDetailsProvider).value?[item.id];

    if (details == null) {
      return const Center(child: CircularProgressIndicator());
    }

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
          await Clipboard.setData(ClipboardData(text: details.chatLink));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Copied to clipboard'),
              behavior: SnackBarBehavior.floating,
              width: 200,
            ),
          );
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  details.icon,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) =>
                      loadingProgress == null
                          ? child.animate().fadeIn(duration: 500.ms)
                          : Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox.square(
                dimension: 34,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      '${item.count}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms);
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
          const TextSpan(text: 'Vendor value: '),
          if (value > 10000) ...[
            TextSpan(
              text: '${value ~/ 10000}',
            ),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: SizedBox.square(
                dimension: Theme.of(context).textTheme.labelSmall?.fontSize,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFC813),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const TextSpan(text: ' '),
          ],
          if (value > 100) ...[
            TextSpan(
              text: '${(value % 10000) ~/ 100}',
            ),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: SizedBox.square(
                dimension: Theme.of(context).textTheme.labelSmall?.fontSize,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xffc0c0c0),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const TextSpan(text: ' '),
          ],
          TextSpan(
            text: '${value % 100}',
          ),
          // copper colored circle
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: SizedBox.square(
              dimension: Theme.of(context).textTheme.labelSmall?.fontSize,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xffb87333),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
