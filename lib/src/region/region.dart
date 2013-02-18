part of region;

/**
 * Defines a region with 4 vertexes.
 *
 * NOTE: For now this works best if the region is rectangular
 */
class Region {

  final int left;
  final int right;
  final int top;
  final int bottom;

  Region(this.left, this.right, this.top, this.bottom);

}