String getBusinessImage(String category) {
  switch (category) {
    case 'CAFE':
      return 'assets/images/default_cafe.png';

    case 'RESTAURANT':
      return 'assets/images/default_restaurant.png';

    case 'BAKERY':
    case 'JEWELLERY':
    case 'OTHER':
      return 'assets/images/default_shop.png';

    case 'SALON':
    case 'MEDICAL':
      return 'assets/images/default_service.png';

    default:
      return 'assets/images/default_shop.png';
  }
}