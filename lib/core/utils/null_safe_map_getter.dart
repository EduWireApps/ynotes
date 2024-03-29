// Returns value of map[p1][p2]...[pn]
// where path = [p1, p2, ..., pn]
//
// example: mapGet(map, ["foo", 9, 'c'])
dynamic mapGet(var map, List path) {
  assert(path.isNotEmpty);
  var m = map ?? {};
  for (int i = 0; i < path.length - 1; i++) {
    m = m[path[i]] ?? {};
  }

  return m[path.last];
}
