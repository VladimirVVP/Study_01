public with sharing class ReviewTriggerHandler {
   public static void ratingValidation(List<Review__c> reviewList){
       for(Review__c review : reviewList){
           if(review.Rating__c < 1){
               review.Rating__c = 1;
           } else if(review.Rating__c > 5){
               review.Rating__c = 5;
           }
       }
   }
}
