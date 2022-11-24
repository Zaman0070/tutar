import 'package:flutter/material.dart';


class SliderModel{

  String? imageAssetPath;
  String? title;
  String? desc;

  SliderModel({this.imageAssetPath,this.title,this.desc});

  void setImageAssetPath(String getImageAssetPath){
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle){
    title = getTitle;
  }

  void setDesc(String getDesc){
    desc = getDesc;
  }

  String getImageAssetPath(){
    return imageAssetPath!;
  }

  String getTitle(){
    return title!;
  }

  String getDesc(){
    return desc!;
  }

}


List<SliderModel> getSlides(){

  List<SliderModel> slides =  <SliderModel>[];
  SliderModel sliderModel =  SliderModel();

  //1
  sliderModel.setDesc("We’re here to disrupt the way Islam\nis currently taught, offering an unparalleled Madrasah combining modern teaching standards with traditional Islamic studies.");
  sliderModel.setTitle("Madarsah is now\nconvenient, modernized,\nand evolved.");
  sliderModel.setImageAssetPath("assets/images/onb1.png");
  slides.add(sliderModel);

  sliderModel =  SliderModel();

  //2
  sliderModel.setDesc("Now communication with your instructor\nhas improved like never before. Receive daily reminders so you never miss a Zoom session!");
  sliderModel.setTitle("An app that is\nenabling students around\nthe globe!");
  sliderModel.setImageAssetPath("assets/images/onb2.png");
  slides.add(sliderModel);

  sliderModel =  SliderModel();

  //3


  return slides;
}