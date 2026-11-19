import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../core/config.dart';
import '../../model/item.dart';
import '../../service/api_service.dart';
import '../widgets/error_retry.dart';
import '../widgets/item_card.dart';
import '../widgets/item_tile.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Item> _items = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _isGrid = kUseGrid;
  String _query = '';
  String _selectedCategory = kAllLabel;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    if (_items.isEmpty) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }
    try {
      final items = await ApiService.getItems();
      if (!mounted) return;
      setState(() {
        _items = items;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().replaceFirst('Exception: ', '');
      setState(() {
        _isLoading = false;
        _errorMessage = message;
      });
      if (_items.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyegarkan: $message')),
        );
      }
    }
  }

  List<String> get _categories {
    final names = _items
        .map((item) => item.category)
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    return [kAllLabel, ...names];
  }

  List<Item> get _filteredItems {
    return _items.where((item) {
      final matchCategory =
          _selectedCategory == kAllLabel || item.category == _selectedCategory;
      final matchQuery =
          item.title.toLowerCase().contains(_query.toLowerCase());
      return matchCategory && matchQuery;
    }).toList();
  }

  void _openDetail(Item item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(item: item)),
    );
  }

  Widget _buildCategoryChips() {
    final categories = _categories;
    if (!kShowCategoryFilter || categories.length <= 1) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final name = categories[index];
          return ChoiceChip(
            label: Text(name, style: const TextStyle(fontSize: 12)),
            selected: _selectedCategory == name,
            selectedColor: kAccent,
            onSelected: (_) => setState(() => _selectedCategory = name),
          );
        },
      ),
    );
  }

  Widget _buildList(List<Item> items) {
    if (_isGrid) {
      return GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.62,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) => ItemCard(
          item: items[index],
          onTap: () => _openDetail(items[index]),
        ),
      );
    }
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (context, index) => ItemTile(
        item: items[index],
        onTap: () => _openDetail(items[index]),
        trailing: const Padding(
          padding: EdgeInsets.only(right: 8),
          child: Icon(Icons.chevron_right, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: kAccent));
    }
    if (_errorMessage != null && _items.isEmpty) {
      return ErrorRetry(message: _errorMessage!, onRetry: _fetchItems);
    }
    final items = _filteredItems;
    if (items.isEmpty) {
      return const Center(child: Text('Data tidak ditemukan'));
    }
    return RefreshIndicator(
      color: kAccent,
      onRefresh: _fetchItems,
      child: _buildList(items),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(kHomeTitle, style: TextStyle(fontSize: 16)),
        actions: [
          IconButton(
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Cari...',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          _buildCategoryChips(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }
}
