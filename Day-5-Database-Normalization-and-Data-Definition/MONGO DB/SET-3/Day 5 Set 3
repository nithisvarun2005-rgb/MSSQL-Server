use('HospitalDB');

db.createCollection("clinicalNotes", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["patientId", "visitId", "diagnosis", "noteDate"],
            properties: {
                patientId: { bsonType: "int" },
                visitId: { bsonType: "int" },
                diagnosis: { bsonType: "string" },
                noteDate: { bsonType: "date" },
                doctorNotes: { bsonType: "string" },
                bloodPressure: { bsonType: "string" },
                heartRate: { bsonType: "int" },
                skinObservations: { bsonType: "string" },
                allergies: { bsonType: "array", items: { bsonType: "string" } },
                prescription: { bsonType: "string" },
                followUp: { bsonType: "string" }
            }
        }
    },
    validationLevel: "strict",
    validationAction: "error"
});

db.clinicalNotes.insertMany([
    {
        patientId: NumberInt(1),
        visitId: NumberInt(1),
        diagnosis: "High Blood Pressure",
        noteDate: new Date("2026-10-05"),
        doctorNotes: "Patient reports occasional headaches.",
        bloodPressure: "150/95",
        heartRate: NumberInt(90),
        prescription: "Blood pressure medication",
        followUp: "Review after two weeks"
    },
    {
        patientId: NumberInt(5),
        visitId: NumberInt(5),
        diagnosis: "Skin Allergy",
        noteDate: new Date("2026-10-20"),
        doctorNotes: "Patient has redness and itching.",
        skinObservations: "Red patches on arms",
        allergies: ["Dust", "Pollen"],
        prescription: "Antihistamine",
        followUp: "Review after one week"
    }
]);

db.clinicalNotes.find();

db.clinicalNotes.find({ diagnosis: "High Blood Pressure" });

db.clinicalNotes.find({ diagnosis: "Skin Allergy" });

db.clinicalNotes.countDocuments();
