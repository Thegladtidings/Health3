import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";

actor Health3 {

  type Patient = {
    id: Text;
    name: Text;
    age: Nat;
    records: Buffer.Buffer<Text>;
  };

  var patients = Buffer.Buffer<Patient>(0);

  public func addPatient(id: Text, name: Text, age: Nat) : async Text {
    for (p in patients.vals()) {
      if (p.id == id) return "Patient already exists.";
    };
    patients.add({ id = id; name = name; age = age; records = Buffer.Buffer<Text>(0) });
    return "Patient added.";
};


public func addRecord(id: Text, record: Text) : async Text {
  for (i in Iter.range(0, patients.size() - 1)) {
    switch (patients.getOpt(i)) {
      case (?p) {
        if (p.id == id) {
          // Mutate the records buffer in place
          p.records.add(record);
          // Replace the patient at index i (if needed, depending on your structure)
          patients.put(i, p); // or patients.set(i, p) depending on your Buffer/array type
          return "Record added.";
        };
      };
      case null {};
    };
  };
  return "Patient not found.";
};


  public query func getRecords(id: Text) : async [Text] {
    for (p in patients.vals()) {
      if (p.id == id) return Buffer.toArray(p.records);
    };
    return [];
  };

  public query func getPatient(id: Text) : async ?(Text, Text, Nat) {
    for (p in patients.vals()) {
      if (p.id == id) return ?(p.id, p.name, p.age);
    };
    return null;
  };
};