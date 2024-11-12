enum MuscleGroup {
  chest,
  back,
  legs,
  biceps,
  triceps,
  shoulders,
}

String muscleGroupReadable(MuscleGroup group) {
  return switch (group) {
    MuscleGroup.chest => 'Chest',
    MuscleGroup.back => 'Back',
    MuscleGroup.legs => 'Legs',
    MuscleGroup.biceps => 'Biceps',
    MuscleGroup.triceps => 'Triceps',
    MuscleGroup.shoulders => 'Shoulders',
  };
}

// enum CuisineFilter {
//   italian,
//   mexican,
//   american,
//   french,
//   japanese,
//   chinese,
//   indian,
//   greek,
//   moroccan,
//   ethiopian,
//   southAfrican,
// }

// enum BasicequipmentFilter {
//   oil,
//   butter,
//   flour,
//   salt,
//   pepper,
//   sugar,
//   milk,
//   vinegar,
// } 

// enum DietaryRestrictionsFilter {
//   vegan,
//   vegetarian,
//   lactoseIntolerant,
//   kosher,
//   // keto,
//   wheatAllergies,
//   nutAllergies,
//   fishAllergies,
//   soyAllergies,
// }

// String dietaryRestrictionReadable(DietaryRestrictionsFilter filter) {
//   return switch (filter) {
//     DietaryRestrictionsFilter.vegan => 'vegan',
//     DietaryRestrictionsFilter.vegetarian => 'vegetarian',
//     DietaryRestrictionsFilter.lactoseIntolerant => 'dairy free',
//     DietaryRestrictionsFilter.kosher => 'kosher',
//     // DietaryRestrictionsFilter.keto => 'low carb',
//     DietaryRestrictionsFilter.wheatAllergies => 'wheat allergy',
//     DietaryRestrictionsFilter.nutAllergies => 'nut allergy',
//     DietaryRestrictionsFilter.fishAllergies => 'fish allergy',
//     DietaryRestrictionsFilter.soyAllergies => 'soy allergy',
//   };
// }

// String cuisineReadable(CuisineFilter filter) {
//   return switch (filter) {
//     CuisineFilter.italian => 'Italian',
//     CuisineFilter.mexican => 'Mexican',
//     CuisineFilter.american => 'American',
//     CuisineFilter.french => 'French',
//     CuisineFilter.japanese => 'Japanese',
//     CuisineFilter.chinese => 'Chinese',
//     CuisineFilter.indian => 'Indian',
//     CuisineFilter.ethiopian => 'Ethiopian',
//     CuisineFilter.moroccan => 'Moroccan',
//     CuisineFilter.greek => 'Greek',
//     CuisineFilter.southAfrican => 'South African',
//   };
// }
