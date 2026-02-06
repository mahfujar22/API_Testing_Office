// // lib/features/products/presentation/product_details_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:template_flutter/common_widgets/custom_appbar.dart';
// import 'package:template_flutter/common_widgets/app_network_image.dart';
// import 'package:template_flutter/common_widgets/no_data_widget.dart';
// import 'package:template_flutter/common_widgets/not_found_widget.dart';
// import 'package:template_flutter/common_widgets/waiting_widget.dart';
// import 'package:template_flutter/constants/text_font_style.dart';
// import 'package:template_flutter/gen/colors.gen.dart';
// import 'package:template_flutter/helpers/ui_helpers.dart';
// import 'package:template_flutter/networks/api_acess.dart';

// import '../model/products_details_model.dart';

// class ProductDetailsScreen extends StatefulWidget {
//   final int productId;

//   const ProductDetailsScreen({super.key, required this.productId});

//   @override
//   State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
// }

// class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Assuming you have a product details API call method
//     productDetailsRxObj.featchProductDetails(id: widget.productId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         showBackArrow: true,
//         title: Text(
//           "Product Details",
//           style: TextFontStyle.textStyle18c172B4DDMSans500,
//         ),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: StreamBuilder(
//           stream: productDetailsRxObj.fileData,
//           builder: (context, snapshot) {

//                  if (snapshot.data == productDetailsRxObj.empty) {
//           return const WaitingWidget();
//         }
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const WaitingWidget();
//             } else if (snapshot.hasData && snapshot.data != null) {
//               final responseData = snapshot.data!;

//               // Parse the response
//               ProductDetailsResModel productDetailsResponse;
//               try {
//                 productDetailsResponse = ProductDetailsResModel.fromJson(responseData as Map<String, dynamic>);
//               } catch (e) {
//                 return const NoDataWidget(
//                   title: 'Data Error',
//                   subtitle: 'Failed to parse product details',
//                 );
//               }

//               if (productDetailsResponse.data?.product == null) {
//                 return const NoDataWidget(
//                   title: 'Product Not Found',
//                   subtitle: 'The product details are not available.',
//                 );
//               }

//               final product = productDetailsResponse.data!.product!;

//               return SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Product Images
//                     _buildProductImages(product),
                    
//                     // Product Details
//                     _buildProductDetails(product),
                    
//                     // Description
//                     _buildDescription(product),
                    
//                     // Additional Information
//                     _buildAdditionalInfo(product),
//                   ],
//                 ),
//               );
//             } else if (snapshot.hasError) {
//               return const NotFoundWidget();
//             } else {
//               // For demo - replace with actual API call
//               return _buildDemoProductDetails();
//             }
//           },
//         ),
//       ),
//       bottomNavigationBar: _buildBottomBar(),
//     );
//   }

//   Widget _buildProductImages(Product product) {
//     return Column(
//       children: [
//         // Main Image
//         Container(
//           height: 300.h,
//           width: double.infinity,
//           color: AppColors.cF5F5F5,
//           child: AppNetworkImage(
//             imageUrl: product.image ?? '',
//             height: 300.h,
//             width: double.infinity,
//             fit: BoxFit.contain,
//             customErrorWidget: Container(
//               height: 300.h,
//               width: double.infinity,
//               color: AppColors.cE8E8E8,
//               child: Icon(
//                 Icons.image_not_supported_outlined,
//                 size: 60.sp,
//                 color: AppColors.c949494,
//               ),
//             ),
//           ),
//         ),
        
//         // Gallery Images (if available)
//         if (product.galleryImages != null && product.galleryImages!.isNotEmpty)
//           Container(
//             height: 80.h,
//             padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: product.galleryImages!.length,
//               itemBuilder: (context, index) {
//                 return Container(
//                   width: 60.w,
//                   height: 60.h,
//                   margin: EdgeInsets.only(right: 8.w),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: AppColors.cE8E8E8),
//                     borderRadius: BorderRadius.circular(8.r),
//                   ),
//                   child: AppNetworkImage(
//                     imageUrl: product.galleryImages![index].toString(),
//                     height: 60.h,
//                     width: 60.w,
//                     fit: BoxFit.cover,
//                   ),
//                 );
//               },
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildProductDetails(Product product) {
//     return Padding(
//       padding: EdgeInsets.all(16.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Product Name
//           Text(
//             product.name ?? 'No Name',
//             style: TextFontStyle.textStyle20c202020DMSans600,
//           ),
          
//           UIHelper.verticalSpace(8.h),
          
//           // Rating
//           Row(
//             children: [
//               Icon(
//                 Icons.star,
//                 size: 16.sp,
//                 color: AppColors.cFFD700,
//               ),
//               UIHelper.horizontalSpace(4.w),
//               Text(
//                 product.rating ?? '0',
//                 style: TextFontStyle.textStyle14c606060DMSans400,
//               ),
//               UIHelper.horizontalSpace(8.w),
//               Text(
//                 '(${product.reviewCount ?? 0} reviews)',
//                 style: TextFontStyle.textStyle12c949494DMSans400,
//               ),
//             ],
//           ),
          
//           UIHelper.verticalSpace(12.h),
          
//           // Price
//           Row(
//             children: [
//               if (product.onSale == true && product.salePrice?.isNotEmpty == true)
//                 Text(
//                   '\$${product.regularPrice ?? '0.00'}',
//                   style: TextFontStyle.textStyle16c606060DMSans400.copyWith(
//                     decoration: TextDecoration.lineThrough,
//                   ),
//                 ),
//               UIHelper.horizontalSpace(8.w),
//               Text(
//                 '\$${_getDisplayPrice(product)}',
//                 style: TextFontStyle.textStyle22cFF3A1222DMSans600,
//               ),
//               if (product.onSale == true) ...[
//                 UIHelper.horizontalSpace(8.w),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
//                   decoration: BoxDecoration(
//                     color: AppColors.c4CAF50,
//                     borderRadius: BorderRadius.circular(4.r),
//                   ),
//                   child: Text(
//                     'SALE',
//                     style: TextFontStyle.textStyle10cFFFFFFDMSans400,
//                   ),
//                 ),
//               ],
//             ],
//           ),
          
//           UIHelper.verticalSpace(12.h),
          
//           // Stock Status
//           Row(
//             children: [
//               Container(
//                 width: 8.w,
//                 height: 8.h,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: (product.inStock ?? false) ? AppColors.c4CAF50 : AppColors.cF44336,
//                 ),
//               ),
//               UIHelper.horizontalSpace(8.w),
//               Text(
//                 (product.inStock ?? false) ? 'In Stock' : 'Out of Stock',
//                 style: TextFontStyle.textStyle14c202020DMSans500,
//               ),
//               UIHelper.horizontalSpace(16.w),
//               Text(
//                 'SKU: ${product.sku ?? 'N/A'}',
//                 style: TextFontStyle.textStyle12c949494DMSans400,
//               ),
//             ],
//           ),
          
//           UIHelper.verticalSpace(12.h),
          
//           // Categories
//           if (product.categories != null && product.categories!.isNotEmpty)
//             Wrap(
//               spacing: 8.w,
//               children: product.categories!.map((category) {
//                 return Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//                   decoration: BoxDecoration(
//                     color: AppColors.cF5F5F5,
//                     borderRadius: BorderRadius.circular(4.r),
//                   ),
//                   child: Text(
//                     category.name ?? '',
//                     style: TextFontStyle.textStyle12c606060DMSans400,
//                   ),
//                 );
//               }).toList(),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDescription(Product product) {
//     if (product.description?.isEmpty ?? true) {
//       return const SizedBox.shrink();
//     }

//     return Padding(
//       padding: EdgeInsets.all(16.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Description',
//             style: TextFontStyle.textStyle18c202020DMSans600,
//           ),
//           UIHelper.verticalSpace(8.h),
//           Text(
//             _cleanHtmlText(product.description ?? ''),
//             style: TextFontStyle.textStyle14c606060DMSans400.copyWith(
//               height: 1.5,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAdditionalInfo(Product product) {
//     return Padding(
//       padding: EdgeInsets.all(16.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Additional Information',
//             style: TextFontStyle.textStyle18c202020DMSans600,
//           ),
//           UIHelper.verticalSpace(12.h),
          
//           _buildInfoRow('Product Type', product.type ?? 'N/A'),
//           _buildInfoRow('Stock Status', product.stockStatus ?? 'N/A'),
//           if (product.shortDescription?.isNotEmpty ?? false)
//             _buildInfoRow('Short Description', _cleanHtmlText(product.shortDescription!)),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoRow(String title, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8.h),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               title,
//               style: TextFontStyle.textStyle14c202020DMSans600,
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: Text(
//               value,
//               style: TextFontStyle.textStyle14c606060DMSans400,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomBar() {
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: AppColors.cFFFFFF,
//         border: Border(top: BorderSide(color: AppColors.cE8E8E8),),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.c000000.withOpacity(0.1),
//             blurRadius: 8.r,
//             offset: Offset(0, -2.h),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // Add to Cart Button
//           Expanded(
//             child: ElevatedButton(
//               onPressed: () {
//                 // Add to cart functionality
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.allPrimaryColor,
//                 foregroundColor: AppColors.cFFFFFF,
//                 padding: EdgeInsets.symmetric(vertical: 14.h),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.r),
//                 ),
//               ),
//               child: Text(
//                 'Add to Cart',
//                 style: TextFontStyle.textStyle16cFFFFFFDMSans600,
//               ),
//             ),
//           ),
//           UIHelper.horizontalSpace(12.w),
//           // Buy Now Button
//           Expanded(
//             child: ElevatedButton(
//               onPressed: () {
//                 // Buy now functionality
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.c4CAF50,
//                 foregroundColor: AppColors.cFFFFFF,
//                 padding: EdgeInsets.symmetric(vertical: 14.h),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.r),
//                 ),
//               ),
//               child: Text(
//                 'Buy Now',
//                 style: TextFontStyle.textStyle16cFFFFFFDMSans600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _getDisplayPrice(Product product) {
//     if (product.price?.isNotEmpty ?? false) {
//       return product.price!;
//     } else if (product.regularPrice?.isNotEmpty ?? false) {
//       return product.regularPrice!;
//     } else if (product.salePrice?.isNotEmpty ?? false) {
//       return product.salePrice!;
//     }
//     return '0.00';
//   }

//   String _cleanHtmlText(String htmlText) {
//     // Simple HTML tag removal - you might want to use a proper HTML parser
//     return htmlText
//         .replaceAll(RegExp(r'<[^>]*>'), '')
//         .replaceAll('&nbsp;', ' ')
//         .trim();
//   }

//   // Demo product for testing (remove when API is connected)
//   Widget _buildDemoProductDetails() {
//     final demoProduct = Product(
//       id: 1,
//       name: "Demo Product",
//       price: "29.99",
//       regularPrice: "39.99",
//       salePrice: "29.99",
//       onSale: true,
//       image: "https://via.placeholder.com/400",
//       rating: "4.5",
//       reviewCount: 25,
//       stockStatus: "instock",
//       inStock: true,
//       description: "This is a demo product description with some details about the product features and benefits.",
//       shortDescription: "Short description of the product",
//       sku: "DEMO123",
//       type: "simple",
//       categories: [
//         Category(id: 1, name: "Electronics", slug: "electronics"),
//         Category(id: 2, name: "Mobile", slug: "mobile"),
//       ],
//     );

//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildProductImages(demoProduct),
//           _buildProductDetails(demoProduct),
//           _buildDescription(demoProduct),
//           _buildAdditionalInfo(demoProduct),
//         ],
//       ),
//     );
//   }
// }