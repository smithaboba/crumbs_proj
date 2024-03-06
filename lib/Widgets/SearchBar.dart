import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/item_model.dart';


/// Flutter code sample for [Autocomplete] that demonstrates fetching the
/// options asynchronously and debouncing the network calls, including handling
/// network errors.

const Duration fakeAPIDuration = Duration(seconds: 1);
const Duration debounceDuration = Duration(milliseconds: 500);



class SearchBarWidget extends StatefulWidget {
  SearchBarWidget({super.key, required this.dbRef, required this.itemsList});
  final DatabaseReference dbRef;
  final List<Item> itemsList;

  @override
  State<SearchBarWidget> createState(){
     return _SearchBarWidgetState(
     );
  }
  
  
}

  //late final Iterable<String?> _kOptions = itemsList.map((entry) => entry.itemData!.name!.toLowerCase());
  
  
class _SearchBarWidgetState extends State<SearchBarWidget>
{
  List<String>? optionsList_Global;

  bool isLoading = false;
  Future getSearchResults() async
  {
    setState(() {
      isLoading = true;
    });
    List<Item> itemsList2 = widget.itemsList;
    //print("THIS IS ITEMLIST2"+itemsList2.toString());
    print("THIS IS ITEMLIST ORIGINAL"+widget.itemsList.toString());
    List<String> optionsList = itemsList2.map((entry) => entry.itemData!.name!.toLowerCase()).toList();
    print("THIS IS optionLIST AGAINAGAIN"+optionsList.toString());

    //List<String> optionsList = itemsList2.map((entry) => entry.itemData!.name!).toList();

    setState(() {
      isLoading = false;
      optionsList_Global = optionsList;
    });
  }

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    
    getSearchResults();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Text(
            //    'Type below to search for a Item: ${_FakeAPI._kOptions}.'),
            const SizedBox(height: 20.0),
            Autocomplete(
              optionsBuilder: 
              (TextEditingValue textEditingValue) {
                  if(textEditingValue.text.isEmpty)
                  {
                    return const Iterable<String>.empty();
                  }
                  else
                  {
                    return optionsList_Global!.where((element) => element.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                  }
                }, 
              ),
            //const _AsyncAutocomplete(),
          ],
        ),
      ),
    );
  }
}
 

/*
class _AsyncAutocomplete extends StatefulWidget {
  const _AsyncAutocomplete();

  @override
  State<_AsyncAutocomplete> createState() => _AsyncAutocompleteState();
}*/

/*
class _AsyncAutocompleteState extends State<_AsyncAutocomplete> {
  // The query currently being searched for. If null, there is no pending
  // request.
  String? _currentQuery;

  // The most recent options received from the API.
  late Iterable<String> _lastOptions = <String>[];

  late final _Debounceable<Iterable<String>?, String> _debouncedSearch;

  // Whether to consider the fake network to be offline.
  bool _networkEnabled = true;

  // A network error was recieved on the most recent query.
  bool _networkError = false;

  // Calls the "remote" API to search with the given query. Returns null when
  // the call has been made obsolete.

  //List<String?> 
  Future<Iterable<String>?> _search(String query) async {
    _currentQuery = query;

    late final Iterable<String> options;
    try {
      //options = await _FakeAPI.search(_currentQuery!, _networkEnabled);
    } catch (error) {
      if (error is _NetworkException) {
        setState(() {
          _networkError = true;
        });
        return <String>[];
      }
      rethrow;
    }

    // If another search happened after this one, throw away these options.
    if (_currentQuery != query) {
      return null;
    }
    _currentQuery = null;

    return options;
  }

  @override
  void initState() {
    super.initState();
    _debouncedSearch = _debounce<Iterable<String>?, String>(_search);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          _networkEnabled
              ? 'Network is on, toggle to induce network errors.'
              : 'Network is off, toggle to allow requests to go through.',
        ),
        Switch(
          value: _networkEnabled,
          onChanged: (bool? value) {
            setState(() {
              _networkEnabled = !_networkEnabled;
            });
          },
        ),
        const SizedBox(
          height: 32.0,
        ),
        Autocomplete<String>(
          fieldViewBuilder: (BuildContext context,
              TextEditingController controller,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted) {
            return TextFormField(
              decoration: InputDecoration(
                errorText:
                    _networkError ? 'Network error, please try again.' : null,
              ),
              controller: controller,
              focusNode: focusNode,
              onFieldSubmitted: (String value) {
                onFieldSubmitted();
              },
            );
          },
          optionsBuilder: (TextEditingValue textEditingValue) async {
            setState(() {
              _networkError = false;
            });
            final Iterable<String>? options =
                await _debouncedSearch(textEditingValue.text);
            if (options == null) {
              return _lastOptions;
            }
            _lastOptions = options;
            return options;
          },
          onSelected: (String selection) {
            
            debugPrint('You just selected $selection');
          },
        ),
      ],
    );
  }
}*/


/*
// Mimics a remote API.
class _FakeAPI{
  List<Item> itemsList;
  _FakeAPI(
    this.itemsList,
  );
  
  late final Iterable<String?> _kOptions = itemsList.map((entry) => entry.itemData!.name!.toLowerCase());

  // Searches the options, but injects a fake "network" delay.
  static Future<Iterable<String>> search(
      String query, bool networkEnabled) async {
    await Future<void>.delayed(fakeAPIDuration); // Fake 1 second delay.
    if (!networkEnabled) {
      throw const _NetworkException();
    }
    if (query == '') {
      return const Iterable<String>.empty();
    }
    return _kOptions.where((String option) {
      return option.contains(query.toLowerCase());
    });
  }
}*/

typedef _Debounceable<S, T> = Future<S?> Function(T parameter);

/// Returns a new function that is a debounced version of the given function.
///
/// This means that the original function will be called only after no calls
/// have been made for the given Duration.
_Debounceable<S, T> _debounce<S, T>(_Debounceable<S?, T> function) {
  _DebounceTimer? debounceTimer;

  return (T parameter) async {
    if (debounceTimer != null && !debounceTimer!.isCompleted) {
      debounceTimer!.cancel();
    }
    debounceTimer = _DebounceTimer();
    try {
      await debounceTimer!.future;
    } catch (error) {
      if (error is _CancelException) {
        return null;
      }
      rethrow;
    }
    return function(parameter);
  };
}

// A wrapper around Timer used for debouncing.
class _DebounceTimer {
  _DebounceTimer() {
    _timer = Timer(debounceDuration, _onComplete);
  }

  late final Timer _timer;
  final Completer<void> _completer = Completer<void>();

  void _onComplete() {
    _completer.complete();
  }

  Future<void> get future => _completer.future;

  bool get isCompleted => _completer.isCompleted;

  void cancel() {
    _timer.cancel();
    _completer.completeError(const _CancelException());
  }
}

// An exception indicating that the timer was canceled.
class _CancelException implements Exception {
  const _CancelException();
}

// An exception indicating that a network request has failed.
class _NetworkException implements Exception {
  const _NetworkException();
}
