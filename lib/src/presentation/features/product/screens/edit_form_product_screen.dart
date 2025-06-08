import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:pos_app/src/core/shared/theme.dart';
import 'package:pos_app/src/core/utils/field_helper.dart';
import 'package:pos_app/src/core/utils/string_helper.dart';
import 'package:pos_app/src/presentation/features/product/index.dart';
import 'package:pos_app/src/presentation/widgets/custom_dropdown_form_field.dart';
import 'package:pos_app/src/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditFormProductScreen extends StatefulWidget {
  const EditFormProductScreen({Key? key}) : super(key: key);

  @override
  State<EditFormProductScreen> createState() => _EditFormProductScreenState();
}

class _EditFormProductScreenState extends State<EditFormProductScreen> {
  PlatformFile? file;
  String? imageUrl;

  var _nameController = TextEditingController(text: '');
  var _priceController = TextEditingController(text: '');
  var _hppController = TextEditingController(text: '');
  var _quantityController = TextEditingController(text: '');
  var _minimumQuantityController = TextEditingController(text: '');
  String? valueProductType;
  List<String> listTypeProducts = ['Food', 'Lauk', 'Drink'];

  Future pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = result.files.first;
      context
          .read<EditProductBloc>()
          .add(EditImage(editImage: file!.path.toString()));

      setState(() {});
      // file == null ? false : OpenAppFile.open(file!.path.toString());

      // print(file.name);
      // print(file.bytes);
      // print(file.size);
      // print(file.extension);
      // print(file.path);
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageFromFile() {
      return file == null
          ? Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: gray2Color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Edit Image',
                  style: white2TextStyle,
                ),
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(file!.path.toString()),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            );
    }

    Widget imageFromUrl() {
      return file != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(file!.path.toString()),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            );
    }

    Widget formImage() {
      log('imageUrl: ${imageUrl}');
      log('file: ${file}');
      return Padding(
        padding: const EdgeInsets.only(left: defaultMargin),
        child: GestureDetector(
          onTap: () {
            pickImage();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Image',
                style: primaryTextStyle,
              ),
              const SizedBox(height: 8),
              file == null && imageUrl == '' || imageUrl == null
                  ? Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: gray2Color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Edit Image',
                          style: white2TextStyle,
                        ),
                      ),
                    )
                  : imageFromUrl(),
            ],
          ),
        ),
      );
    }

    Widget formProductName() {
      return CustomTextFormField(
        title: 'Product Name',
        controller: _nameController,
        keyboardType: TextInputType.text,
        hintText: 'Americano',
        textValidator: 'Please enter product name',
        onChanged: (value) {
          context.read<EditProductBloc>().add(EditNameChanged(name: value));
        },
      );
    }

    Widget formPrice() {
      return StatefulBuilder(
        builder: (context, setState) {
          return CustomTextFormField(
            title: 'Price',
            controller: _priceController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            hintText: '0',
            textValidator: 'Please enter price',
            onChanged: (value) {
              int? price = int.tryParse(value);

              FieldHelper.number(
                controller: _priceController,
                value: value,
                setState: (controller) {
                  setState(() {
                    _priceController = controller;
                  });
                },
              );

              if (price != null) {
                context
                    .read<EditProductBloc>()
                    .add(EditPriceChanged(price: price));
              }
            },
          );
        },
      );
    }

    Widget formHpp() {
      return StatefulBuilder(
        builder: (context, setState) {
          return CustomTextFormField(
            title: 'Hpp',
            controller: _hppController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            hintText: '0',
            textValidator: 'Please enter price',
            onChanged: (value) {
              int? hpp = int.tryParse(value);

              FieldHelper.number(
                controller: _hppController,
                value: value,
                setState: (controller) {
                  setState(() {
                    _hppController = controller;
                  });
                },
              );

              if (hpp != null) {
                context.read<EditProductBloc>().add(EditHppChanged(hpp: hpp));
              }
            },
          );
        },
      );
    }

    Widget formQuantity() {
      return CustomTextFormField(
        title: 'Quantity',
        controller: _quantityController,
        hintText: '100',
        textValidator: 'Please enter quantity',
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (value) {
          int? quantity = int.tryParse(value);

          if (quantity != null) {
            context
                .read<EditProductBloc>()
                .add(EditQuantityChanged(quantity: quantity));
          }
        },
      );
    }

    Widget formMinimumQuantity() {
      return CustomTextFormField(
        title: 'Minimum Quantity',
        hintText: '50',
        textValidator: 'Please enter minimum quantity',
        keyboardType: TextInputType.number,
        controller: _minimumQuantityController,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (value) {
          int? minimumQuantity = int.tryParse(value);
          // jika minimumQuantity bisa diparse
          // atau diubah menjadi angka
          // masukan data ke state
          if (minimumQuantity != null) {
            context.read<EditProductBloc>().add(
                EditMinimumQuantityChanged(minimumQuantity: minimumQuantity));
          }
        },
      );
    }

    Widget selectProductType() {
      return CustomDropdownFormField(
        title: 'Product Type',
        value: valueProductType,
        listDropdown: listTypeProducts,
        textValidator: 'Please select Product type',
        onChanged: (value) {
          context
              .read<EditProductBloc>()
              .add(EditTypeProductChanged(typeProduct: value.toString()));
        },
      );
    }

    return BlocConsumer<EditProductBloc, EditProductState>(
      listener: (context, state) {
        if (state.status == EditStatus.successFetch) {
          _nameController = TextEditingController(text: state.name);
          _priceController = TextEditingController(
            text: StringHelper.addComma(state.price!),
          );
          _hppController = TextEditingController(
            text: StringHelper.addComma(state.hpp!),
          );
          _quantityController = TextEditingController(
            text: StringHelper.addComma(state.quantity!),
          );
          _minimumQuantityController = TextEditingController(
            text: StringHelper.addComma(state.minimumQuantity!),
          );
          valueProductType = state.typeMenu!;
          imageUrl = state.image;
        }
      },
      builder: (context, state) {
        if (state.status == EditStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            formImage(),
            const SizedBox(height: 16),
            formProductName(),
            const SizedBox(height: 16),
            formPrice(),
            const SizedBox(height: 16),
            formHpp(),
            const SizedBox(height: 16),
            formQuantity(),
            const SizedBox(height: 16),
            formMinimumQuantity(),
            const SizedBox(height: 16),
            selectProductType(),
          ],
        );
      },
    );
  }
}
