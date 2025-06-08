enum Role {
  owner('pemilik'),
  pelayan('pelayan');

  const Role(this.value);
  final String value;

  static Role getTypeByTitle(String title) {
    return Role.values.firstWhere((r) {
      return r.value == title;
    });
  }

  static String getValue(Role role) {
    return Role.values.firstWhere((r) {
      return r.name == role.name;
    }).value;
  }
}
// const StatusInventory(this.value);
//   final String value;

//   static StatusInventory getTypeByTitle(String title) {
//     return StatusInventory.values.firstWhere((status) {
//       return status.value == title;
//     });
//   }

//   static String getValue(StatusInventory statusInventory) {
//     return StatusInventory.values.firstWhere((status) {
//       return status.name == statusInventory.name;
//     }).value;
//   }}
  
