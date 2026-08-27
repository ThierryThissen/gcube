void Function(void Function()) _mainSet = (void Function() x) => x();
set mainState(void Function(void Function()) it) => _mainSet = it;
void rebuildMainStack(void Function() it) => _mainSet(it);

