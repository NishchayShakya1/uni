import 'dart:collection';
import 'package:uni/model/utils/day_of_week.dart';

import 'meal.dart';

class Restaurant{
  int id;
  String name;
  String reference; // Used only in html parser
  HashMap<DayOfWeek, List<Meal>> meals;
  Restaurant(String name, String reference, int id, {List<Meal> meals = null}){
    this.id = id;
    this.name = name;
    this.reference = reference;
    this.meals = HashMap<DayOfWeek, List<Meal>>();

    DayOfWeek.values.forEach((dayOfWeek) => this.meals[dayOfWeek] = []);
    meals.forEach((meal) {
      meal.assignRestaurant(this);
      this.addMeal(meal);
    });


  }



  void addMeal(Meal meal){
    meals[meal.dayOfWeek].add(meal);
  }

  List<Meal> getMealsOfDay(DayOfWeek dayOfWeek){
    return meals[dayOfWeek];
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'name': name,
      'ref': reference
    };
  }







}