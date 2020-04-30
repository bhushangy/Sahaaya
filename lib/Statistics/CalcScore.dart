import 'package:voter_grievance_redressal/Statistics/RankingDetails.dart';

abstract class CalculateScore{
  void getCount();
  void calculateScore();
}






class DisplayScore extends CalculateScore{
  @override

  String res;
  String nres;
  String score;
  @override
  void getCount() {
    // TODO: Ashwitha
    //get count of one constiyuency here or take constituency name as parameter & get count from firebase & store in var
  }


  void calculateScore() {
    // TODO: Ashwitha
  }



}