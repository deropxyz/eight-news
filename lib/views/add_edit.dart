import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/news_article.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../views/utils/helper.dart';

class AddEditNewsScreen extends StatefulWidget {
  final NewsArticle? article;
  const AddEditNewsScreen({this.article, Key? key}) : super(key: key);

  @override
  _AddEditNewsScreenState createState() => _AddEditNewsScreenState();
}

class _AddEditNewsScreenState extends State<AddEditNewsScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _summaryController;
  late TextEditingController _categoryController;

  bool _isLoading = false;

  final String _defaultImageUrl = 'https:google.com/images/';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.article?.title ?? '');
    _contentController = TextEditingController(
      text: widget.article?.content ?? '',
    );
    _summaryController = TextEditingController(
      text: widget.article?.summary ?? '',
    );
    _categoryController = TextEditingController(
      text: widget.article?.category ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _summaryController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  // Save form data
  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Get the token and create ApiService instance
    final token = Provider.of<AuthService>(context, listen: false).token;
    final apiService = ApiService(token);

    try {
      final newArticle = NewsArticle(
        id: widget.article?.id,
        title: _titleController.text,
        content: _contentController.text,
        summary: _summaryController.text,
        category: _categoryController.text,
        featuredImageUrl: _defaultImageUrl,
        tags: widget.article?.tags ?? ["general"],
        isPublished: widget.article?.isPublished ?? true,
      );

      // Create or update the article
      if (widget.article == null) {
        await apiService.createNews(newArticle);
      } else {
        await apiService.updateNews(widget.article!.id!, newArticle);
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder:
              (ctx) => AlertDialog(
                title: const Text('Terjadi Kesalahan'),
                content: Text('Gagal menyimpan berita: $e'),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
        );
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBg,
      appBar: AppBar(
        backgroundColor: cBg,
        elevation: 0,
        iconTheme: IconThemeData(color: cTextGreyLight),
        title: Text(
          widget.article == null ? 'Tambah Berita' : 'Edit Berita',
          style: TextStyle(color: cTextGreyLight),
        ),
        centerTitle: true,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //form judul
                      TextFormField(
                        controller: _titleController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Judul',
                          labelStyle: TextStyle(color: Colors.grey[400]),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        validator:
                            (value) =>
                                (value == null || value.isEmpty)
                                    ? 'Judul tidak boleh kosong'
                                    : null,
                      ),
                      const SizedBox(height: 16),

                      //form ringkasan
                      TextFormField(
                        controller: _summaryController,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Ringkasan (Summary)',
                          labelStyle: TextStyle(color: Colors.grey[400]),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        validator:
                            (value) =>
                                (value != null && value.length < 10)
                                    ? 'Ringkasan minimal 10 karakter'
                                    : null,
                      ),
                      const SizedBox(height: 16),

                      //form konten lengkap
                      TextFormField(
                        controller: _contentController,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 8,
                        decoration: InputDecoration(
                          labelText: 'Konten Lengkap',
                          labelStyle: TextStyle(color: Colors.grey[400]),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        validator:
                            (value) =>
                                (value != null && value.length < 10)
                                    ? 'Konten minimal 10 karakter'
                                    : null,
                      ),
                      const SizedBox(height: 16),

                      //form kategori
                      TextFormField(
                        controller: _categoryController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Kategori',
                          labelStyle: TextStyle(color: Colors.grey[400]),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        validator:
                            (value) =>
                                (value == null || value.isEmpty)
                                    ? 'Kategori tidak boleh kosong'
                                    : null,
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _saveForm,
                          child: Text(
                            widget.article == null
                                ? 'Tambah Berita'
                                : 'Update Berita',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
