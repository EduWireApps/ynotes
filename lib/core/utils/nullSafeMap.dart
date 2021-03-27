// Returns value of map[p1][p2]...[pn]
// where path = [p1, p2, ..., pn]
//
// example: mapGet(map, ["foo", 9, 'c'])
dynamic mapGet(Map map, List path) {
  assert(path.length > 0);
  var m = map ?? const {};
  for (int i = 0; i < path.length - 1; i++) {
    m = m[path[i]] ?? const {};
  }

  return m[path.last];
}
