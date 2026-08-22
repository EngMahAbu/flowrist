sealed class OccasionEvents {}

class GetOccasionsEvent extends OccasionEvents {}

class GetProductsByOccasionEvent extends OccasionEvents {
  final String occasionId;

  GetProductsByOccasionEvent(this.occasionId);
}

class SelectOccasionEvent extends OccasionEvents {
  final int index;

  SelectOccasionEvent(this.index);
}