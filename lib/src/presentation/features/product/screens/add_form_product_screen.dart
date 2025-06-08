import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:pos_app/src/core/shared/theme.dart';
import 'package:pos_app/src/core/utils/field_helper.dart';
import 'package:pos_app/src/presentation/features/product/index.dart';
import 'package:pos_app/src/presentation/widgets/custom_dropdown_form_field.dart';
import 'package:pos_app/src/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddFormProductScreen extends StatefulWidget {
  const AddFormProductScreen({Key? key}) : super(key: key);

  @override
  State<AddFormProductScreen> createState() => _AddFormProductScreenState();
}

class _AddFormProductScreenState extends State<AddFormProductScreen> {
  PlatformFile? file;
  var _priceController = TextEditingController(text: '');
  var _hppController = TextEditingController(text: '');
  List<String> listTypeProducts = ['Food', 'Lauk', 'Drink'];

  @override
  Widget build(BuildContext context) {
    Future pickImage() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        file = result.files.first;
        context
            .read<AddProductBloc>()
            .add(AddImage(image: file!.path.toString()));
        log('file: ${file}');

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

    Widget formImage() {
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
              file == null
                  ? Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: gray2Color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Add Image',
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
                    ),
            ],
          ),
        ),
      );
    }

    Widget formProductName() {
      return CustomTextFormField(
        title: 'Product Name',
        keyboardType: TextInputType.text,
        hintText: 'Rendang',
        textValidator: 'Please enter product name',
        onChanged: (value) =>
            context.read<AddProductBloc>().add(NameChanged(name: value)),
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
                context.read<AddProductBloc>().add(PriceChanged(price: price));
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
                context.read<AddProductBloc>().add(HppChanged(hpp: hpp));
              }
            },
          );
        },
      );
    }

    Widget formQuantity() {
      return CustomTextFormField(
        title: 'Quantity',
        hintText: '100',
        textValidator: 'Please enter quantity',
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (value) {
          int? quantity = int.tryParse(value);
          // jika quantity bisa diparse
          // atau diubah menjadi angka
          // masukan data ke state
          if (quantity != null) {
            context
                .read<AddProductBloc>()
                .add(QuantityChanged(quantity: quantity));
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
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (value) {
          int? minimumQuantity = int.tryParse(value);
          // jika minimumQuantity bisa diparse
          // atau diubah menjadi angka
          // masukan data ke state
          if (minimumQuantity != null) {
            context
                .read<AddProductBloc>()
                .add(MinimumQuantityChanged(minimumQuantity: minimumQuantity));
          }
        },
      );
    }

    Widget selectProductType() {
      return CustomDropdownFormField(
        title: 'Product Type',
        listDropdown: listTypeProducts,
        textValidator: 'Please select Product type',
        onChanged: (value) {
          log('value: ${value}');
          context
              .read<AddProductBloc>()
              .add(TypeProductChanged(typeProduct: value.toString()));
        },
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
  }
}
