import '../auth/auth_util.dart';
import '../backend/backend.dart';
import '../backend/firebase_storage/storage.dart';
import '../flutter_flow/flutter_flow_animations.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../flutter_flow/upload_media.dart';
import '../onboarding/onboarding_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class CompleteProfileWidget extends StatefulWidget {
  const CompleteProfileWidget({Key key}) : super(key: key);

  @override
  _CompleteProfileWidgetState createState() => _CompleteProfileWidgetState();
}

class _CompleteProfileWidgetState extends State<CompleteProfileWidget>
    with TickerProviderStateMixin {
  String uploadedFileUrl = '';
  TextEditingController yourNameController;
  TextEditingController yourAgeController;
  TextEditingController yourTitleController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = {
    'circleImageOnPageLoadAnimation': AnimationInfo(
      curve: Curves.bounceOut,
      trigger: AnimationTrigger.onPageLoad,
      duration: 600,
      fadeIn: true,
      initialState: AnimationState(
        offset: Offset(0, 19),
        opacity: 0,
      ),
      finalState: AnimationState(
        offset: Offset(0, 0),
        opacity: 1,
      ),
    ),
    'textOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      duration: 600,
      delay: 50,
      fadeIn: true,
      initialState: AnimationState(
        offset: Offset(0, 20),
        opacity: 0,
      ),
      finalState: AnimationState(
        offset: Offset(0, 0),
        opacity: 1,
      ),
    ),
    'textFieldOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      duration: 600,
      delay: 100,
      fadeIn: true,
      initialState: AnimationState(
        offset: Offset(0, 20),
        opacity: 0,
      ),
      finalState: AnimationState(
        offset: Offset(0, 0),
        opacity: 1,
      ),
    ),
    'textFieldOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      duration: 600,
      delay: 200,
      fadeIn: true,
      initialState: AnimationState(
        offset: Offset(0, 40),
        opacity: 0,
      ),
      finalState: AnimationState(
        offset: Offset(0, 0),
        opacity: 1,
      ),
    ),
    'textFieldOnPageLoadAnimation3': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      duration: 600,
      delay: 200,
      fadeIn: true,
      initialState: AnimationState(
        offset: Offset(0, 60),
        opacity: 0,
      ),
      finalState: AnimationState(
        offset: Offset(0, 0),
        opacity: 1,
      ),
    ),
    'buttonOnPageLoadAnimation1': AnimationInfo(
      curve: Curves.bounceOut,
      trigger: AnimationTrigger.onPageLoad,
      duration: 600,
      delay: 400,
      fadeIn: true,
      initialState: AnimationState(
        offset: Offset(0, 40),
        opacity: 0,
      ),
      finalState: AnimationState(
        offset: Offset(0, 0),
        opacity: 1,
      ),
    ),
    'buttonOnPageLoadAnimation2': AnimationInfo(
      curve: Curves.bounceOut,
      trigger: AnimationTrigger.onPageLoad,
      duration: 600,
      delay: 400,
      fadeIn: true,
      initialState: AnimationState(
        offset: Offset(0, 40),
        opacity: 0,
      ),
      finalState: AnimationState(
        offset: Offset(0, 0),
        opacity: 1,
      ),
    ),
  };

  @override
  void initState() {
    super.initState();
    startPageLoadAnimations(
      animationsMap.values
          .where((anim) => anim.trigger == AnimationTrigger.onPageLoad),
      this,
    );

    yourAgeController = TextEditingController();
    yourNameController = TextEditingController();
    yourTitleController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF14181B),
        automaticallyImplyLeading: false,
        title: Text(
          'Complete Profile',
          style: FlutterFlowTheme.of(context).title3,
        ),
        actions: [],
        centerTitle: false,
        elevation: 0,
      ),
      backgroundColor: FlutterFlowTheme.of(context).background,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 1,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: Image.asset(
              'assets/images/bgapp.jpeg',
            ).image,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                child: InkWell(
                  onTap: () async {
                    final selectedMedia =
                        await selectMediaWithSourceBottomSheet(
                      context: context,
                      allowPhoto: true,
                      backgroundColor:
                          FlutterFlowTheme.of(context).darkBackground,
                      textColor: FlutterFlowTheme.of(context).textColor,
                      pickerFontFamily: 'Lexend Deca',
                    );
                    if (selectedMedia != null &&
                        validateFileFormat(
                            selectedMedia.storagePath, context)) {
                      showUploadMessage(
                        context,
                        'Uploading file...',
                        showLoading: true,
                      );
                      final downloadUrl = await uploadData(
                          selectedMedia.storagePath, selectedMedia.bytes);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      if (downloadUrl != null) {
                        setState(() => uploadedFileUrl = downloadUrl);
                        showUploadMessage(
                          context,
                          'Success!',
                        );
                      } else {
                        showUploadMessage(
                          context,
                          'Failed to upload media',
                        );
                        return;
                      }
                    }
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.network(
                      valueOrDefault<String>(
                        uploadedFileUrl,
                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/finance-app-sample-kugwu4/assets/ijvuhvqbvns6/uiAvatar@2x.png',
                      ),
                    ),
                  ),
                ).animated([animationsMap['circleImageOnPageLoadAnimation']]),
              ),
              Text(
                'Upload a photo for us to easily identify you.',
                style: FlutterFlowTheme.of(context).bodyText1,
              ).animated([animationsMap['textOnPageLoadAnimation']]),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: TextFormField(
                  controller: yourNameController,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Your Name',
                    labelStyle: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Lexend Deca',
                          color: FlutterFlowTheme.of(context).grayLight,
                        ),
                    hintStyle: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Lexend Deca',
                          color: Color(0x98FFFFFF),
                        ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).darkBackground,
                    contentPadding:
                        EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                  ),
                  style: FlutterFlowTheme.of(context).bodyText1.override(
                        fontFamily: 'Lexend Deca',
                        color: FlutterFlowTheme.of(context).textColor,
                      ),
                ).animated([animationsMap['textFieldOnPageLoadAnimation1']]),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: TextFormField(
                  controller: yourAgeController,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Your Age',
                    labelStyle: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Lexend Deca',
                          color: FlutterFlowTheme.of(context).grayLight,
                        ),
                    hintText: 'i.e. 34',
                    hintStyle: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Lexend Deca',
                          color: Color(0x98FFFFFF),
                        ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).darkBackground,
                    contentPadding:
                        EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                  ),
                  style: FlutterFlowTheme.of(context).bodyText1.override(
                        fontFamily: 'Lexend Deca',
                        color: FlutterFlowTheme.of(context).textColor,
                      ),
                  keyboardType: TextInputType.number,
                ).animated([animationsMap['textFieldOnPageLoadAnimation2']]),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: TextFormField(
                  controller: yourTitleController,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Your Title',
                    labelStyle: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Lexend Deca',
                          color: FlutterFlowTheme.of(context).grayLight,
                        ),
                    hintText: 'What is your position?',
                    hintStyle: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Lexend Deca',
                          color: Color(0x98FFFFFF),
                        ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).darkBackground,
                    contentPadding:
                        EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                  ),
                  style: FlutterFlowTheme.of(context).bodyText1.override(
                        fontFamily: 'Lexend Deca',
                        color: FlutterFlowTheme.of(context).textColor,
                      ),
                ).animated([animationsMap['textFieldOnPageLoadAnimation3']]),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: StreamBuilder<UsersRecord>(
                  stream: UsersRecord.getDocument(currentUserReference),
                  builder: (context, snapshot) {
                    // Customize what your widget looks like when it's loading.
                    if (!snapshot.hasData) {
                      return Center(
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: SpinKitFadingCircle(
                            color: FlutterFlowTheme.of(context).primaryColor,
                            size: 40,
                          ),
                        ),
                      );
                    }
                    final buttonLoginUsersRecord = snapshot.data;
                    return FFButtonWidget(
                      onPressed: () async {
                        final usersUpdateData = createUsersRecordData(
                          displayName: yourNameController.text,
                          age: int.parse(yourAgeController.text),
                          userTitle: yourTitleController.text,
                          photoUrl: '',
                        );
                        await buttonLoginUsersRecord.reference
                            .update(usersUpdateData);
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OnboardingWidget(),
                          ),
                        );
                      },
                      text: 'Complete Profile',
                      options: FFButtonOptions(
                        width: 230,
                        height: 50,
                        color: FlutterFlowTheme.of(context).primaryColor,
                        textStyle:
                            FlutterFlowTheme.of(context).subtitle2.override(
                                  fontFamily: 'Lexend Deca',
                                  color: FlutterFlowTheme.of(context).textColor,
                                ),
                        elevation: 3,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: 30,
                      ),
                    ).animated([animationsMap['buttonOnPageLoadAnimation1']]);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: StreamBuilder<UsersRecord>(
                  stream: UsersRecord.getDocument(currentUserReference),
                  builder: (context, snapshot) {
                    // Customize what your widget looks like when it's loading.
                    if (!snapshot.hasData) {
                      return Center(
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: SpinKitFadingCircle(
                            color: FlutterFlowTheme.of(context).primaryColor,
                            size: 40,
                          ),
                        ),
                      );
                    }
                    final buttonLoginUsersRecord = snapshot.data;
                    return FFButtonWidget(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OnboardingWidget(),
                          ),
                        );
                      },
                      text: 'Skip for Now',
                      options: FFButtonOptions(
                        width: 140,
                        height: 50,
                        color: FlutterFlowTheme.of(context).background,
                        textStyle:
                            FlutterFlowTheme.of(context).subtitle2.override(
                                  fontFamily: 'Lexend Deca',
                                  color: FlutterFlowTheme.of(context).textColor,
                                ),
                        elevation: 0,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: 30,
                      ),
                    ).animated([animationsMap['buttonOnPageLoadAnimation2']]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
