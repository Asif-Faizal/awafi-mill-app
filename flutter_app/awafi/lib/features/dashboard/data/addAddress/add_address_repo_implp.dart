import '../../domain/addAddress/add_address_entity.dart';
import '../../domain/addAddress/add_address_repo.dart';
import 'add_address_datasource.dart';
import 'add_address_model.dart';

class AddAddressRepositoryImpl implements AddAddressRepository {
  final AddAddressDatasource datasource;

  AddAddressRepositoryImpl({required this.datasource});

  @override
  Future<Map<String, dynamic>> addAddress(AddAddressEntity address) async {
    final addressModel = AddAddressModel(
      addressLine1: address.addressLine1,
      addressLine2: address.addressLine2,
      city: address.city,
      postalCode: address.postalCode,
      country: address.country,
    );
    return await datasource.addAddress(addressModel);
  }
}