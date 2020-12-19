/*BlocListener<ClassBloc, ClassState>(
              listener: (context, state) {
                if (state is ClassUpdated) {
                  Navigator.pop(context);
                } else if (state is Error) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                }
              },
              child:
                  BlocBuilder<ClassBloc, ClassState>(builder: (context, state) {
                return Container(
                  height: 80,
                  padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                  child: RaisedButton(
                    child: Text(
                      'Save Changes',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      print("Changes Saved");
                      print("name: " +
                          firstnameController.text +
                          ' ' +
                          lastnameController.text);
                      print("email: " + emailController.text);
                      print("password: " +
                          passwordController
                              .text); //só falta checar se as senhas batem uma com a outra
                      print("role: " + roleSelected.toString());
                      _userBloc.add(
                        UpdateClassEvent(
                          firstnameController.text,
                          lastnameController.text,
                          emailController.text,
                          roleSelected,
                          passwordController.text,
                        ),
                      );
                    },
                  ),
                );
              }),
            ),*/
