import 'package:critical_x_quiz/core/model/questionModel/question_model.dart';
import 'package:critical_x_quiz/core/tools/flutter_toast.dart';
import 'package:critical_x_quiz/ui/dialog/dialog_router.dart';
import 'package:critical_x_quiz/ui/router/app_router.dart';
import 'package:critical_x_quiz/ui/widget/button/questionNextButton.dart';
import 'package:flutter/material.dart';

class EditQuestion extends StatefulWidget {
  QuestionModel questionModel;

  EditQuestion({this.questionModel});

  @override
  _EditQuestionState createState() => _EditQuestionState();
}

class _EditQuestionState extends State<EditQuestion> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController categoryController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  TextEditingController optionAController = TextEditingController();
  TextEditingController optionBController = TextEditingController();
  TextEditingController optionCController = TextEditingController();
  TextEditingController optionDController = TextEditingController();
  TextEditingController optionEController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String correctAns;

  setValue() {
    questionController.text = widget?.questionModel?.question ?? "";
    categoryController.text = widget?.questionModel?.category ?? "";
    optionAController.text = widget?.questionModel?.option1 ?? "";
    optionBController.text = widget?.questionModel?.option2 ?? "";
    optionCController.text = widget?.questionModel?.option3 ?? "";
    optionDController.text = widget?.questionModel?.option4 ?? "";
    optionEController.text = widget?.questionModel?.option5 ?? "";
    descriptionController.text = widget?.questionModel?.description ?? "";
    correctAns = widget?.questionModel?.answer ?? '';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.questionModel.category),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                          color: Colors.black12)
                    ]),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Category',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w900),
                            //WeightHeavy
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: categoryController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'cannot be empty';
                              }
                              return null;
                            },
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF0C1A35),
                                fontWeight: FontWeight.w500),
                            //WeightHeavy
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Question 1',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w900),
                            //WeightHeavy
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: questionController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'cannot be empty';
                              }
                              return null;
                            },
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF0C1A35),
                                fontWeight: FontWeight.w500),
                            //WeightHeavy
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    // padding: const EdgeInsets.symmetric(horizontal: 20),
                    padding:
                        const EdgeInsets.only(top: 15, left: 20, right: 20),
                    child: Card(
                      shape: optionAController.text == correctAns
                          ? RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Color(0xffFD5959), width: 1.0),
                              borderRadius: BorderRadius.circular(15.0),
                            )
                          : RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                      elevation: 10,
                      shadowColor: Colors.black26,
                      child: ListTile(
                        leading: Text(
                          "A.",
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF0C1A35),
                              fontWeight: FontWeight.w600),
                        ),
                        title: TextFormField(
                          controller: optionAController,
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return 'cannot be empty';
                          //   }
                          //   return null;
                          // },
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF0C1A35),
                              fontWeight: FontWeight.w600),
                        ),
                        trailing: InkWell(
                          radius: 10,
                          onTap: () {
                            setState(() {
                              correctAns = optionAController.text;
                            });
                          },
                          child: Container(
                              decoration: optionAController.text == correctAns
                                  ? BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffFD5959))
                                  : BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffF1F1F1)),
                              child: Icon(
                                Icons.check,
                                size: 25.0,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    // padding: const EdgeInsets.symmetric(horizontal: 20),
                    padding:
                        const EdgeInsets.only(top: 15, left: 20, right: 20),
                    child: Card(
                      shape: optionBController.text == correctAns
                          ? RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Color(0xffFD5959), width: 1.0),
                              borderRadius: BorderRadius.circular(15.0),
                            )
                          : RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                      elevation: 10,
                      shadowColor: Colors.black26,
                      child: ListTile(
                        leading: Text(
                          "B.",
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF0C1A35),
                              fontWeight: FontWeight.w600),
                        ),
                        title: TextFormField(
                          controller: optionBController,
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return 'cannot be empty';
                          //   }
                          //   return null;
                          // },
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF0C1A35),
                              fontWeight: FontWeight.w600),
                        ),
                        trailing: InkWell(
                          radius: 10,
                          onTap: () {
                            setState(() {
                              correctAns = optionBController.text;
                            });
                          },
                          child: Container(
                              decoration: correctAns == optionBController.text
                                  ? BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffFD5959))
                                  : BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffF1F1F1)),
                              child: Icon(
                                Icons.check,
                                size: 25.0,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    // padding: const EdgeInsets.symmetric(horizontal: 20),
                    padding:
                        const EdgeInsets.only(top: 15, left: 20, right: 20),
                    child: Card(
                      shape: correctAns == optionCController.text
                          ? RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Color(0xffFD5959), width: 1.0),
                              borderRadius: BorderRadius.circular(15.0),
                            )
                          : RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                      elevation: 10,
                      shadowColor: Colors.black26,
                      child: ListTile(
                        leading: Text(
                          "C.",
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF0C1A35),
                              fontWeight: FontWeight.w600),
                        ),
                        title: TextFormField(
                          controller: optionCController,
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return 'cannot be empty';
                          //   }
                          //   return null;
                          // },
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF0C1A35),
                              fontWeight: FontWeight.w600),
                        ),
                        trailing: InkWell(
                          radius: 10,
                          onTap: () {
                            setState(() {
                              correctAns = optionCController.text;
                            });
                          },
                          child: Container(
                              decoration: correctAns == optionCController.text
                                  ? BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffFD5959))
                                  : BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffF1F1F1)),
                              child: Icon(
                                Icons.check,
                                size: 25.0,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    // padding: const EdgeInsets.symmetric(horizontal: 20),
                    padding:
                        const EdgeInsets.only(top: 15, left: 20, right: 20),
                    child: Card(
                      shape: correctAns == optionDController.text
                          ? RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Color(0xffFD5959), width: 1.0),
                              borderRadius: BorderRadius.circular(15.0),
                            )
                          : RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                      elevation: 10,
                      shadowColor: Colors.black26,
                      child: ListTile(
                        leading: Text(
                          "D.",
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF0C1A35),
                              fontWeight: FontWeight.w600),
                        ),
                        title: TextFormField(
                          controller: optionDController,
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return 'cannot be empty';
                          //   }
                          //   return null;
                          // },
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF0C1A35),
                              fontWeight: FontWeight.w600),
                        ),
                        trailing: InkWell(
                          radius: 10,
                          onTap: () {
                            setState(() {
                              correctAns = optionDController.text;
                            });
                          },
                          child: Container(
                              decoration: correctAns == optionDController.text
                                  ? BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffFD5959))
                                  : BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffF1F1F1)),
                              child: Icon(
                                Icons.check,
                                size: 25.0,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    // padding: const EdgeInsets.symmetric(horizontal: 20),
                    padding:
                        const EdgeInsets.only(top: 15, left: 20, right: 20),
                    child: Card(
                      shape: correctAns == optionEController.text
                          ? RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Color(0xffFD5959), width: 1.0),
                              borderRadius: BorderRadius.circular(15.0),
                            )
                          : RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                      elevation: 10,
                      shadowColor: Colors.black26,
                      child: ListTile(
                        leading: Text(
                          "E.",
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF0C1A35),
                              fontWeight: FontWeight.w600),
                        ),
                        title: TextFormField(
                          controller: optionEController,
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return 'cannot be empty';
                          //   }
                          //   return null;
                          // },
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF0C1A35),
                              fontWeight: FontWeight.w600),
                        ),
                        trailing: InkWell(
                          radius: 10,
                          onTap: () {
                            setState(() {
                              correctAns = optionEController.text;
                            });
                          },
                          child: Container(
                              decoration: correctAns == optionEController.text
                                  ? BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffFD5959))
                                  : BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffF1F1F1)),
                              child: Icon(
                                Icons.check,
                                size: 25.0,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ),

                  ///------------
                  Padding(
                    // padding: const EdgeInsets.symmetric(horizontal: 20),
                    padding:
                        const EdgeInsets.only(top: 15, left: 20, right: 20),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 10,
                      shadowColor: Colors.black26,
                      child: ListTile(
                        leading: Text(
                          "Description.",
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF0C1A35),
                              fontWeight: FontWeight.w600),
                        ),
                        title: TextFormField(
                          controller: descriptionController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'cannot be empty';
                            }
                            return null;
                          },
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF0C1A35),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 0),
                    child: QuestionNextButton(
                      text: 'Update',
                      backGroundColor: Color(0xFFFD5959),
                      onPress: () {
                        if (_formKey.currentState.validate()) {
                          DialogRouter.displayConfirmDialog(
                            context: context,
                            titleText: 'Update!',
                            bodyText: 'Are you sure to update the Question?',
                            yesPress: () {
                              widget.questionModel.delete();
                              QuestionModel(
                                category: "${categoryController.text}".trim(),
                                question: "${questionController.text}".trim(),
                                option1: "${optionAController.text}".trim(),
                                option2: "${optionBController.text}".trim(),
                                option3: "${optionCController.text}".trim(),
                                option4: "${optionDController.text}".trim(),
                                option5: "${optionEController.text}".trim(),
                                // answer: widget.questionModel.answer,
                                answer: correctAns,
                                description:
                                    "${descriptionController.text}".trim(),
                              ).save();
                              FlutterToast.showSuccess(
                                  message: "Question Updated",
                                  context: context);
                              AppRouter.back();
                              setState(() {});
                            },
                            noPress: () {
                              AppRouter.back();
                            },
                          );
                        } else {
                          FlutterToast.showErrorToast(
                              context: context,
                              message: 'check All fields please');
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: QuestionNextButton(
                      text: 'Delete',
                      backGroundColor: Color(0xFFFD5959),
                      onPress: () {
                        DialogRouter.displayConfirmDialog(
                          context: context,
                          titleText: 'Delete!',
                          bodyText: 'Are you sure to Delete the Question ?',
                          yesPress: () {
                            widget.questionModel.delete();

                            FlutterToast.showSuccess(
                                message: "Deleted", context: context);
                            AppRouter.back();
                            AppRouter.back();

                            setState(() {});
                          },
                          noPress: () {
                            AppRouter.back();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
