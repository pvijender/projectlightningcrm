import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ListViewJsonapi extends StatefulWidget {
  _ListViewJsonapiState createState() => _ListViewJsonapiState();
}

class _ListViewJsonapiState extends State<ListViewJsonapi> {
  final String uri = 'http://listingtracker.buzzboard.com:3000/';

  Future<List<Jobs>> _fetchJobs() async {
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      print('jobids list response ${response.body}');
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Jobs> listOfJobs = items.map<Jobs>((json) {
        return Jobs.fromJson(json);
      }).toList();
//      List<Users> listOfUsers = items.map<Users>((json) {
//        return Users.fromJson(json);
//      }).toList();
      print('jobs list $listOfJobs');
      return listOfJobs;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetching data from JSON - ListView'),
      ),
      body: FutureBuilder<List<Jobs>>(
        future: _fetchJobs(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          return ListView(
            children: snapshot.data
                .map((job) => ListTile(
              title: Text(job.jobId??'Job ID'),
              subtitle: Text(job.source??'job source'),
              leading: CircleAvatar(
                backgroundColor: Colors.red,
                child: Text(job.source[0]??'user no name',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    )),
              ),
            ))
                .toList(),
          );
        },
      ),
    );
  }
}


class Jobs {
  String jobId;
  String source;
  int userID;
  int partnerID;
  SF sfObj;
  SMBAdvisor smbAdvisorObj;

  Jobs({
    this.jobId,
    this.source,
    this.userID,
    this.partnerID,
    this.sfObj,
    this.smbAdvisorObj,
  });

  factory Jobs.fromJson(Map<String, dynamic> json) {
    return Jobs(
      jobId: json['job_id'],
      source: json['source'],
      userID: json['user_id'],
      partnerID: json['partner_id'],
      sfObj: SF.fromJson(json['sf']) ,
//      smbAdvisorObj: SMBAdvisor.fromJson(json['smb_advisor']??''),
    );
  }
}

class SF {
  int totalSFListings;
  int completedSFListings;
  int pendingSFListings;

  SF({
    this.totalSFListings,
    this.completedSFListings,
    this.pendingSFListings
  });

  factory SF.fromJson(Map<String, dynamic> json) {
    return SF(
        totalSFListings: json['total_sf_listings'],
        completedSFListings: json['completed_sf_listings'],
        pendingSFListings: json['pending_sf_listings'],
    );
  }
}

class SMBAdvisor {
  int eligibleSMBListings;
  int dupeSMBListings;
  int totalSMBListings;
  int completedSMBListings;
  int pendingSMBListings;

  SMBAdvisor({
    this.eligibleSMBListings,
    this.dupeSMBListings,
    this.totalSMBListings,
    this.completedSMBListings,
    this.pendingSMBListings,
  });

  factory SMBAdvisor.fromJson(Map<String, dynamic> json) {
    return SMBAdvisor(
        eligibleSMBListings: json['eligible_smb_listings'],
        dupeSMBListings: json['dupe_smb_listings'],
        totalSMBListings: json['total_smb_listings'],
        completedSMBListings: json['completed_smb_listings'],
        pendingSMBListings: json['pending_smb_listings'],
    );
  }
}